defmodule PrometheusEx.Mixfile do
  use Mix.Project

  @source_url "https://github.com/prometheus-erl/prometheus.ex"
  @version "5.0.0"

  def project do
    [
      app: :prometheus_ex,
      version: @version,
      elixir: "~> 1.7",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      name: "Prometheus.ex",
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      docs: [
        main: Prometheus,
        source_ref: "v#{@version}",
        source_url: @source_url,
        extras: [
          "pages/prometheus_and_grafana_setup.md",
          "pages/Mnesia Collector.md",
          "pages/VM Memory Collector.md",
          "pages/VM Statistics Collector.md",
          "pages/VM System Info Collector.md",
          "pages/Time.md"
        ]
      ]
    ]
  end

  def application do
    [extra_applications: [:logger, :mnesia]]
  end

  defp description do
    """
    Elixir-friendly Prometheus monitoring system client.
    """
  end

  defp package do
    [
      maintainers: ["Ilya Khaprov", "Nelson Vides"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Prometheus.erl" => "https://hex.pm/packages/prometheus",
        "Inets HTTPD Exporter" => "https://hex.pm/packages/prometheus_httpd",
        "Ecto Instrumenter" => "https://hex.pm/packages/prometheus_ecto",
        "Phoenix Instrumenter" => "https://hex.pm/packages/prometheus_phoenix",
        "Plugs Instrumenter/Exporter" => "https://hex.pm/packages/prometheus_plugs",
        "Process info Collector" => "https://hex.pm/packages/prometheus_process_collector"
      }
    ]
  end

  defp deps do
    [
      {:prometheus, "~> 6.0"},

      ## test
      {:credo, "~> 1.0", only: [:dev, :test]},
      {:dialyxir, "~> 1.4", only: [:dev]},
      {:earmark, "~> 1.4", only: [:dev]},
      {:ex_doc, "~> 0.38", only: [:dev]},
      {:excoveralls, "~> 0.18", only: [:test]}
    ]
  end
end
