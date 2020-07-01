release.build:
	mix release --overwrite

release.run:
	QUEUE_NAME=http://localhost:9324/queue/broadway-demo \
	AWS_SQS_ACCESS_KEY_ID=x \
	AWS_SQS_SECRET_ACCESS_KEY=x \
	AWS_SQS_REGION=elasticmq \
	AWS_SQS_HOST=localhost \
	AWS_SQS_PORT=9324 \
	SCHEME=http:// \
	_build/dev/rel/broadway_sqs_playground/bin/broadway_sqs_playground start

containers.up:
	docker-compose up -d

demo.generator:
	mix run -e "BroadwaySqsPlayground.Generator.generate(100_000)"

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