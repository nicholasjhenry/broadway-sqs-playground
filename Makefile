containers.up:
	docker-compose up -d

demo.generator:
	mix eval "BroadwaySqsPlayground.Generator.generate(100_000)"

elasticmq.list_queues:
	aws sqs list-queues --endpoint-url http://localhost:9324

elasticmq.send_message:
	aws sqs send-message --queue-url http://localhost:9324/queue/broadway-demo --endpoint-url http://localhost:9324 --message-body "$(MSG)"

elasticmq.receive_message:
	aws sqs receive-message --queue-url http://localhost:9324/queue/broadway-demo --endpoint-url http://localhost:9324

elasticmq.dead_letters:
	aws sqs receive-message --queue-url http://localhost:9324/queue/broadway-demo-dead-letters --endpoint-url http://localhost:9324

elasticmq.audit:
	aws sqs receive-message --queue-url http://localhost:9324/queue/audit-queue-name --endpoint-url http://localhost:9324
