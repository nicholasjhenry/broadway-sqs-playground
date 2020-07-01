FROM elixir:1.10.3-alpine as builder
RUN apk add --no-cache \
    gcc \
    git \
    make \
    musl-dev
RUN mix local.rebar --force && \
    mix local.hex --force
WORKDIR /app
ENV MIX_ENV=prod

FROM builder as deps
COPY mix.* /app/
RUN mix do deps.get --only prod, deps.compile

FROM deps as releaser
COPY . /app/
RUN MIX_ENV=prod mix release

FROM alpine:3.11 as runner
RUN apk add --no-cache -U bash libssl1.1

WORKDIR /app
COPY --from=releaser /app/_build/prod/rel/broadway_sqs_playground /app

RUN \
  adduser -s /bin/sh -u 1001 -G root -h /app -S -D default && \
  chown -R 1001:0 /app
USER default

EXPOSE 4000
ENTRYPOINT ["/app/bin/broadway_sqs_playground"]
CMD ["start"]