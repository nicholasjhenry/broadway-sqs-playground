defmodule BroadwaySqsPlayground.Telemetry do
  use Supervisor
  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      {Telemetry.Metrics.ConsoleReporter, metrics: metrics()},
      # "summary" is not supported
      {TelemetryMetricsPrometheus, [metrics: metrics()]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def metrics do
    [
      # Database Metrics https://hexdocs.pm/ecto/Ecto.Repo.html#module-adapter-specific-events
      summary("broadway_sqs_playground.repo.query.total_time", unit: {:native, :millisecond}),
      summary("broadway_sqs_playground.repo.query.decode_time", unit: {:native, :millisecond}),
      summary("broadway_sqs_playground.repo.query.query_time", unit: {:native, :millisecond}),
      summary("broadway_sqs_playground.repo.query.queue_time", unit: {:native, :millisecond}),
      summary("broadway_sqs_playground.repo.query.idle_time", unit: {:native, :millisecond}),

      # Prometheus: use units `seconds`, specify the name to report
      distribution("broadway_sqs_playground.repo.query.total_time", event_name: [:broadway_sqs_playground, :repo, :query], measurement: :total_time, unit: {:native, :second}, reporter_options: [ buckets: [0.01, 0.025, 0.05, 0.1, 0.2, 0.5, 1]]),
      distribution("broadway_sqs_playground.repo.query.decode_time", event_name: [:broadway_sqs_playground, :repo, :query], measurement: :decode_time, unit: {:native, :second}, reporter_options: [ buckets: [0.01, 0.025, 0.05, 0.1, 0.2, 0.5, 1]]),
      distribution("broadway_sqs_playground.repo.query.queue_time", event_name: [:broadway_sqs_playground, :repo, :query], measurement: :query_time, unit: {:native, :second}, reporter_options: [ buckets: [0.01, 0.025, 0.05, 0.1, 0.2, 0.5, 1]]),
      distribution("broadway_sqs_playground.repo.query.query_time", event_name: [:broadway_sqs_playground, :repo, :query], measurement: :query_time, unit: {:native, :second}, reporter_options: [ buckets: [0.01, 0.025, 0.05, 0.1, 0.2, 0.5, 1]]),
      distribution("broadway_sqs_playground.repo.query.idle_time", event_name: [:broadway_sqs_playground, :repo, :query], measurement: :idel_time, unit: {:native, :second}, reporter_options: [ buckets: [0.01, 0.025, 0.05, 0.1, 0.2, 0.5, 1]]),

      # Broadway Metrics
      # dispatched by processor when the internal GenStage handle_events/3 callback has completed
      # processing all the individual messages
      summary("broadway.processor.stop.duration", unit: {:native, :millisecond}, tags: [:name]),
      # dispatched by a processor after your handle_message/3 callback has returned
      summary("broadway.processor.message.stop.duration", unit: {:native, :millisecond}, tags: [:name]),
      # dispatched by a Broadway processor if your handle_message/3 callback encounters an exception
      summary("broadway.processor.message.exception.duration", unit: {:native, :millisecond}, tags: [:name]),
      # dispatched by a Broadway consumer after your handle_batch/4 callback has returned
      summary("broadway.consumer.stop.duration", unit: {:native, :millisecond}, tags: [:name]),
      # dispatched by a Broadway batcher after handling events
      summary("broadway.batcher.stop", unit: {:native, :millisecond}, tags: [:name]),

      # VM Metrics
      summary("vm.memory.total", unit: {:byte, :kilobyte}),
      summary("vm.total_run_queue_lengths.total"),
      summary("vm.total_run_queue_lengths.cpu"),
      summary("vm.total_run_queue_lengths.io")
    ]
  end
end
