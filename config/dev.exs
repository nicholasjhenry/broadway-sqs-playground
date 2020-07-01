use Mix.Config

config :broadway_sqs_playground,
  queue_name: "http://localhost:9324/queue/broadway-demo"

config :ex_aws, :sqs,
         access_key_id: "x",
         secret_access_key: "x",
         region: "elasticmq",
         host: "localhost",
         port: "9324",
         scheme: "http://"

config :broadway_sqs_playground, BroadwaySqsPlayground.Repo,
  url: "ecto://root:@localhost/broadway_sqs_playground_dev"
