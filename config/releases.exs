import Config

config :broadway_sqs_playground,
  queue_name: System.fetch_env!("QUEUE_NAME")

config :ex_aws, :sqs,
         access_key_id: System.fetch_env!("AWS_SQS_ACCESS_KEY_ID"),
         secret_access_key: System.fetch_env!("AWS_SQS_SECRET_ACCESS_KEY"),
         region: System.fetch_env!("AWS_SQS_REGION"),
         host: System.fetch_env!("AWS_SQS_HOST"),
         port: System.fetch_env!("AWS_SQS_PORT"),
         scheme: System.fetch_env!("SCHEME")

config :broadway_sqs_playground, BroadwaySqsPlayground.Repo,
  url: System.fetch_env!("DATABASE_URL")
