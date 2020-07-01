defmodule BroadwaySqsPlayground.Generator do
   @start_apps [:ex_aws, :hackney]

  def generate(count \\ 1_000) do
    _ = Application.load(:broadway_sqs_playground)
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    queue_name = Application.fetch_env!(:broadway_sqs_playground, :queue_name)

    Stream.each(1..count, fn _n ->
      sku = generate_sku()
      on_hand = Enum.random(1..100)

      message = Jason.encode!(%{sku: sku, on_hand: on_hand})

      queue_name
      |> ExAws.SQS.send_message(message)
      |> ExAws.request()
      |> IO.inspect()
    end)
    |> Stream.run()
  end

  defp generate_sku() do
    a = Enum.random(1..100)
    b = Enum.random(1..200)
    c = Enum.random(1..300)

    "#{a}.#{b}.#{c}"
  end
end
