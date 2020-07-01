defmodule BroadwaySqsPlayground.Repo do
  use Ecto.Repo,
    otp_app: :broadway_sqs_playground,
    adapter: Ecto.Adapters.MyXQL
end
