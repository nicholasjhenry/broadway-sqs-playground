use Mix.Config

config :broadway_sqs_playground,
  ecto_repos: [BroadwaySqsPlayground.Repo]

import_config "#{Mix.env()}.exs"
