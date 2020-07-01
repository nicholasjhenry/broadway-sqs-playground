defmodule BroadwaySqsPlayground.BroadwayDemo do
  use Broadway

  alias Broadway.Message

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
    message
    |> Message.update_data(fn
      data ->
        data = String.to_integer(data)
        data * data
    end)
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    list = messages |> Enum.map(fn e -> e.data end)

    IO.inspect(list,
      label: "Got batch of finished jobs from processors, sending ACKs to SQS as a batch."
    )

    messages
  end
end
