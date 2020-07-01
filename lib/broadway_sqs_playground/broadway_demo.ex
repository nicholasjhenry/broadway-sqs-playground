defmodule BroadwaySqsPlayground.BroadwayDemo do
  use Broadway

  alias Broadway.Message
  alias BroadwaySqsPlayground.{Repo, StockItem}

  def start_link(_opts) do
    producer =
      {BroadwaySQS.Producer,
       [
         queue_url: Application.fetch_env!(:broadway_sqs_playground, :queue_name),
         config: Application.fetch_env!(:ex_aws, :sqs)
       ]}

    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [module: producer],
      processors: [
        default: []
      ],
      batchers: [
        default: [
          batch_size: 10,
          batch_timeout: 20
        ]
      ]
    )
  end

  @impl true
  def handle_message(_, %Message{} = message, _) do
    Message.update_data(message, &Jason.decode!(&1, keys: :atoms))
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    records = Enum.map(messages, fn e -> e.data end)

    Repo.insert_all(StockItem, records, on_conflict: :replace_all)

    IO.inspect(records,
      label: "Got batch of finished jobs from processors, sending ACKs to SQS as a batch."
    )

    messages
  end
end
