# Prometheus.ex

[![Hex.pm](https://img.shields.io/hexpm/v/prometheus_ex.svg?maxAge=2592000)](https://hex.pm/packages/prometheus_ex)
[![Hex.pm](https://img.shields.io/hexpm/dt/prometheus_ex.svg?maxAge=2592000)](https://hex.pm/packages/prometheus_ex)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/prometheus_ex/)
[![GitHub Actions](https://github.com/prometheus-erl/prometheus.ex/actions/workflows/main.yml/badge.svg)](https://github.com/prometheus-erl/prometheus.ex/actions/workflows/main.yml)
[![Coverage Status](https://coveralls.io/repos/github/prometheus-erl/prometheus.ex/badge.svg?branch=master)](https://coveralls.io/github/prometheus-erl/prometheus.ex?branch=master)
[![Codecov](https://codecov.io/github/prometheus-erl/prometheus.ex/graph/badge.svg?token=G9HB5UKNIY)](https://codecov.io/github/prometheus-erl/prometheus.ex)

Elixir [Prometheus.io](https://prometheus.io) client based on [Prometheus.erl](https://github.com/prometheus-erl/prometheus.erl).

Dashboard from [Monitoring Elixir apps in 2016: Prometheus and Grafana](https://aldusleaf.org/monitoring-elixir-apps-in-2016-prometheus-and-grafana) by [**@skosch**](https://github.com/skosch).

## Example

```elixir
defmodule ExampleInstrumenter do
  use Prometheus.Metric

  def setup do    
    Histogram.new([name: :http_request_duration_milliseconds,
                   labels: [:method],
                   buckets: [100, 300, 500, 750, 1000],
                   help: "Http Request execution time"])
  end

  def instrument(%{time: time, method: method}) do
    Histogram.observe([name: :http_request_duration_milliseconds, labels: [method]], time)
  end
end
```

or

```elixir
defmodule ExampleInstrumenter do
  use Prometheus.Metric

  @histogram [name: :http_request_duration_milliseconds,
              labels: [:method],
              buckets: [100, 300, 500, 750, 1000],
              help: "Http Request execution time"]

  def instrument(%{time: time, method: method}) do
    Histogram.observe([name: :http_request_duration_milliseconds, labels: [method]], time)
  end
end
```

Here histogram will be declared in auto-generated `@on_load` callback, i.e.
you don't have to call setup manually.

Please read how to [measure durations correctly with prometheus.ex](https://hexdocs.pm/prometheus_ex/time.html#content).

## Integrations / Collectors / Instrumenters
 - [Ecto collector](https://github.com/prometheus-erl/prometheus-ecto)
 - [Elli middleware](https://github.com/elli-lib/elli_prometheus)
 - [Extatus - App to report metrics to Prometheus from Elixir GenServers](https://github.com/gmtprime/extatus)
 - [Plugs Instrumenter/Exporter](https://github.com/prometheus-erl/prometheus-plugs)
 - [Fuse plugin](https://github.com/jlouis/fuse#fuse_stats_prometheus)
 - [OS process info Collector](https://hex.pm/packages/prometheus_process_collector) (Linux-only)
 - [Phoenix instrumenter](https://github.com/prometheus-erl/prometheus-phoenix)
 - [RabbitMQ Exporter](https://github.com/prometheus-erl/prometheus_rabbitmq_exporter)

## Dashboards

- [Beam Dashboards](https://github.com/prometheus-erl/beam-dashboards).

## Installation

[Available in Hex](https://hex.pm/packages/prometheus_ex), the package can be installed as:

1. Add `prometheus_ex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:prometheus_ex, "~> 4.0"}]
    end
    ```

2. Ensure `prometheus_ex` is started before your application:

    ```elixir
    def application do
      [applications: [:prometheus_ex]]
    end
    ```
