defmodule BroadwaySqsPlayground.Generator do
  def generate(count \\ 1_000) do
    queue_name = Application.fetch_env!(:broadway_sqs_playground, :queue_name)

    Stream.each(1..count, fn n ->
      queue_name
      |> ExAws.SQS.send_message(n)
      |> ExAws.request()
      |> IO.inspect()
    end)
    |> Stream.run()
  end
end
