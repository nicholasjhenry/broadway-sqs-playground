# BroadwaySqsPlayground

## About Broadway

> Broadway is a concurrent, multi-stage tool for building data ingestion and data processing pipelines.

https://hexdocs.pm/broadway/Broadway.html

The built in features include:

- Back-pressure
- Automatic acknowledgements
- Batching
- Fault tolerance with minimal data loss
- Graceful shutdown
- Built-in testing
- Custom failure handling
- Dynamic batching
- Ordering and Partitioning
- Rate limiting
- Metrics

## About the Demo

This application demonstrates pulling stock notifications from AWS SQS and upserting them
into a database.

https://hexdocs.pm/broadway/amazon-sqs.html

The processing, decoding of the payload is done concurrently with 5 processors and the inserts
are done in batches of 100 records.

![Concurrency](/docs/concurrency.png "Processors in Broadway Pipeline")

## Setup

    git clone https://github.com/nicholasjhenry/broadway-sqs-playground.git
    make container.run
    mix app.setup

## Demo

   # Terminal 1
   iex -S mix
   # Terminal 2
   make demo.generate

## Production

To generate a release in a Docker container:

    make -f ops/prod/Makefile setup
    make -f ops/prod/Makefile container.build

    # To use it locally
    make containers.up
    make -f ops/prod/Makefile container.release
    make -f ops/prod/Makefile container.run
    make -f ops/prod/Makefile container.generator

## Metrics with Telemetry and Prometheus

- Endpoint: http://locahost:9568/metrics
- Prometheus: http://localhost:9090/

### Docs

- https://hexdocs.pm/telemetry_metrics_prometheus/TelemetryMetricsPrometheus.html
- https://hexdocs.pm/telemetry_metrics_prometheus_core/TelemetryMetricsPrometheus.Core.html
- https://hexdocs.pm/ecto/Ecto.Repo.html#module-telemetry-events

### Notes

Metric types:

- Counter - Counter
- Distribution - Histogram
- LastValue - Gauge
- Sum - Counter
- Summary - Summary (Not supported)