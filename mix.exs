defmodule BroadwaySqsPlayground.MixProject do
  use Mix.Project

  def project do
    [
      app: :broadway_sqs_playground,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      releases: [
        broadway_sqs_playground: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {BroadwaySqsPlayground.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_aws, "~> 2.4"},
      {:broadway_sqs, "~> 0.6"},
      {:hackney, "~> 1.16"},
      {:jason, "~> 1.2"},
      {:ecto_sql, "~> 3.4"},
      {:myxql, "~> 0.4.1"},
      {:telemetry_metrics, "~> 0.6.1"},
      {:telemetry_metrics_prometheus, "~> 0.6"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp aliases do
    ["app.setup": [ "deps.get", "compile", "ecto.create", "ecto.migrate"]]
  end
end
