defmodule Prometheus do
  @moduledoc """

  [Prometheus.io](https://prometheus.io) client library powered by
  [prometheus.erl](https://hexdocs.pm/prometheus)

  Prometheus.ex is a thin, mostly macro-based wrapper around prometheus.erl.
  While it's pretty straightforward to use prometheus.erl from Elixir,
  you might prefer prometheus.ex because it gives you:

   - native Elixir syntax;
   - native Elixir exceptions;
   - configuration helpers that are really handy if you plan to write your custom
   instrumenter.

  ```elixir
  defmodule ExampleInstrumenter do
    use Prometheus ## require common Prometheus modules, also alias metrics.

    def setup do
      Histogram.new([name: :http_request_duration_milliseconds,
                     labels: [:method],
                     buckets: [100, 300, 500, 750, 1000],
                     help: "Http Request execution time"])
    end

    def instrument(%{time: time, method: method}) do
      Histogram.observe([name: :http_request_duration_milliseconds,
                         labels: [method]],
                        time)
    end
  end

  ```

  ## Integrations
   - [Ecto Instrumenter](https://hex.pm/packages/prometheus_ecto);
   - [Elixir plugs Instrumenters and Exporter](https://hex.pm/packages/prometheus_plugs);
   - [Fuse plugin](https://github.com/jlouis/fuse#fuse_stats_prometheus)
   - [OS process info Collector](https://hex.pm/packages/prometheus_process_collector)
   (Linux-only);
   - [Phoenix Instrumenter](https://hex.pm/packages/prometheus_phoenix);
   - [RabbitMQ Exporter](https://github.com/deadtrickster/prometheus_rabbitmq_exporter).

  ## Erlang VM Collectors
   - [Memory Collector](vm-memory-collector.html);
   - [Statistics Collector](vm-statistics-collector.html);
   - [System Information Collector](vm-system-info-collector.html).

  ## API

  API can be grouped like this:

  ### Standard Metrics & Registry

   - `Prometheus.Metric.Counter` - counter metric, to track counts of events or running
   totals;
   - `Prometheus.Metric.Gauge` - gauge metric, to report instantaneous values;
   - `Prometheus.Metric.Histogram` - histogram metric, to track distributions of events;
   - `Prometheus.Metric.Summary` - summary metric, to track the size of events;
   - `Prometheus.Registry` - working with Prometheus registries.

  All metrics created via `new/1` or `declare/1` macros. The difference is that `new/1`
  actually wants metric to be new and raises `Prometheus.MFAlreadyExistsError`
  if it isn't.

  Both `new/1` and `declare/1` accept options as
  [Keyword](https://hexdocs.pm/elixir/Keyword.html).
  Common options are:

   - name - metric name, can be an atom or a string (required);
   - help - metric help, string (required);
   - labels - metric labels, label can be an atom or a string (default is []);
   - registry - Prometheus registry for the metric, can be any term. (default is :default)

  Histogram also accepts `buckets` option. Please refer to respective modules docs
  for the more information.

  ### General Helpers

   - `Prometheus.Buckets` - linear or exponential bucket generators;
   - `Prometheus.Contrib.HTTP` - helpers for HTTP instrumenters.

  ### Integration Helpers

   - `Prometheus.Config` - provides standard configuration mechanism
   for custom instrumenters/exporters.

  ### Exposition Formats

   - `Prometheus.Format.Text` - renders metrics for a given registry
   (default is `:default`) in text format;
   - `Prometheus.Format.Protobuf` - renders metrics for a given registry
   (default is `:default`) in protobuf v2 format.

  ### Advanced

  You will need this modules only if you're writing custom collector for app/lib
  that can't be instrumented directly.

   - `Prometheus.Collector` - exports macros for managing/creating collectors;
   - `Prometheus.Model` - provides API for working with underlying Prometheus models.
   You'll use that if you want to create custom collector.

  """

  defmacro __using__(_opts) do
    quote do
      require Prometheus.Collector
      require Prometheus.Registry
      require Prometheus.Buckets
      use Prometheus.Metric
      require Prometheus.Contrib.HTTP
      require Prometheus.Contrib.Mnesia
    end
  end
end
