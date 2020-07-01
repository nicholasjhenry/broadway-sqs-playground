include ops/prod/.env

BIN := QUEUE_NAME=$(QUEUE_NAME) \
	AWS_SQS_ACCESS_KEY_ID=$(AWS_SQS_ACCESS_KEY_ID) \
	AWS_SQS_SECRET_ACCESS_KEY=$(AWS_SQS_SECRET_ACCESS_KEY) \
	AWS_SQS_REGION=$(AWS_SQS_REGION) \
	AWS_SQS_HOST=$(AWS_SQS_HOST) \
	AWS_SQS_PORT=$(AWS_SQS_PORT) \
	SCHEME=$(SCHEME) \ _build/prod/rel/broadway_sqs_playground/bin/broadway_sqs_playground

setup:
	cp ops/prod/.env.sample ops/prod/.env

app.deploy: app.build app.release app.run

app.build:
	MIX_ENV=prod mix release broadway_sqs_playground --force --overwrite

app.release:
	docker-compose up -d

app.run:
	docker-compose up -d
	$(BIN) start

container.build:
	docker build -f ops/prod/Dockerfile -t broadway_sqs_playground:builder --target=builder .
	docker build -f ops/prod/Dockerfile -t broadway_sqs_playground:deps --target=deps .
	docker build -f ops/prod/Dockerfile -t broadway_sqs_playground:releaser --target=releaser .
	echo "Would normally tag with $$(git rev-parse HEAD)"
	docker build -f ops/prod/Dockerfile -t broadway_sqs_playground:latest .

container.release:
	docker run -it --rm --env-file ops/prod/.env --name broadway_sqs_playground broadway_sqs_playground:latest eval "BroadwaySqsPlayground.Release.migrate()"

container.generator:
	docker run -it --rm --env-file ops/prod/.env --name broadway_sqs_playground_generator broadway_sqs_playground:latest eval "BroadwaySqsPlayground.Generator.generate(1_000_000)"

container.run:
	docker run -it --rm --env-file ops/prod/.env --name broadway_sqs_playground broadway_sqs_playground:latest

container.version:
	docker run -it --rm elixir:1.10.3-alpine sh -c 'head -n1 /etc/issue'

container.remote:
	docker exec -it broadway_sqs_playground /app/bin/broadway_sqs_playground remote

container.bash:
	docker run -it --rm --env-file ops/prod/.env --entrypoint /bin/bash broadway_sqs_playground:latest
