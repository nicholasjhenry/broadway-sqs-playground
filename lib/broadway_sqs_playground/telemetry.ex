defmodule BroadwaySqsPlayground.Telemetry do
  use Supervisor
  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      {Telemetry.Metrics.ConsoleReporter, metrics: metrics()}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def metrics do
    [
      # Database Metrics
      summary("broadway_sqs_playground.repo.query.total_time", unit: {:native, :millisecond}),
      summary("broadway_sqs_playground.repo.query.decode_time", unit: {:native, :millisecond}),
      summary("broadway_sqs_playground.repo.query.query_time", unit: {:native, :millisecond}),
      summary("broadway_sqs_playground.repo.query.queue_time", unit: {:native, :millisecond}),
      summary("broadway_sqs_playground.repo.query.idle_time", unit: {:native, :millisecond}),

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
