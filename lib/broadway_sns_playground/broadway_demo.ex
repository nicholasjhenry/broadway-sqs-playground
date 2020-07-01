defmodule BroadwaySnsPlayground.BroadwayDemo do
  use Broadway

  alias Broadway.Message

  def start_link(_opts) do
    producer =
      {BroadwaySQS.Producer,
       queue_url: "http://localhost:9324/queue/broadway-demo",
       config: [
         access_key_id: "x",
         secret_access_key: "x",
         host: "localhost",
         port: "9324",
         scheme: "http://",
         region: "elasticmq"
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
