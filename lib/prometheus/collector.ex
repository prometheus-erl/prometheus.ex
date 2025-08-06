defmodule Prometheus.Collector do
  @moduledoc """
  A collector for a set of metrics.

  Normal users should use `Prometheus.Metric.Gauge`, `Prometheus.Metric.Counter`,
  `Prometheus.Metric.Summary`
  and `Prometheus.Metric.Histogram`.

  Implementing `:prometheus_collector` behaviour is for advanced uses such as proxying
  metrics from another monitoring system.
  It is the responsibility of the implementer to ensure produced metrics are valid.

  You will be working with Prometheus data model directly (see `Prometheus.Model` ).

  Callbacks:
  - `collect_mf(registry, callback)` - called by exporters and formats.
  Should call `callback` for each `MetricFamily` of this collector;
  - `collect_metrics(name, data)` - called by `MetricFamily` constructor.
  Should return Metric list for each MetricFamily identified by `name`.
  `data` is a term associated with MetricFamily by collect_mf.
  - `deregister_cleanup(registry)` - called when collector unregistered by
  `registry`. If collector is stateful you can put cleanup code here.

  Example (simplified [`:prometheus_vm_memory_collector`](https://github.com/prometheus-erl/prometheus.erl/blob/master/doc/prometheus_vm_memory_collector.md)):

  ```
  iex(3)> defmodule Prometheus.VMMemoryCollector do
  ...(3)>   use Prometheus.Collector
  ...(3)>
  ...(3)>   @labels [:processes, :atom, :binary, :code, :ets]
  ...(3)>
  ...(3)>   def collect_mf(_registry, callback) do
  ...(3)>     memory = :erlang.memory()
  ...(3)>     callback.(create_gauge(
  ...(3)>           :erlang_vm_bytes_total,
  ...(3)>           "The total amount of memory currently allocated.",
  ...(3)>           memory))
  ...(3)>     :ok
  ...(3)>   end
  ...(3)>
  ...(3)>   def collect_metrics(:erlang_vm_bytes_total, memory) do
  ...(3)>     Prometheus.Model.gauge_metrics(
  ...(3)>       for label <- @labels do
  ...(3)>         {[type: label], memory[label]}
  ...(3)>       end)
  ...(3)>   end
  ...(3)>
  ...(3)>   defp create_gauge(name, help, data) do
  ...(3)>     Prometheus.Model.create_mf(name, help, :gauge, __MODULE__, data)
  ...(3)>   end
  ...(3)> end
  iex(4)> Prometheus.Registry.register_collector(Prometheus.VMMemoryCollector)
  :ok
  iex(5)> r = ~r/# TYPE erlang_vm_bytes_total gauge
  ...(5)> # HELP erlang_vm_bytes_total
  ...(5)> The total amount of memory currently allocated.
  ...(5)> erlang_vm_bytes_total{type=\"processes\"} [1-9]
  ...(5)> erlang_vm_bytes_total{type=\"atom\"} [1-9]
  ...(5)> erlang_vm_bytes_total{type=\"binary\"} [1-9]
  ...(5)> erlang_vm_bytes_total{type=\"code\"} [1-9]
  ...(5)> erlang_vm_bytes_total{type=\"ets\"} [1-9]/
  iex(6)> Regex.match?(r, Prometheus.Format.Text.format)
  true
  ```
  """

  defmacro __using__(_opts) do
    quote location: :keep do
      @behaviour :prometheus_collector

      require Prometheus.Error
      require Prometheus.Model

      def deregister_cleanup(_registry) do
        :ok
      end

      defoverridable deregister_cleanup: 1
    end
  end

  use Prometheus.Erlang, :prometheus_collector

  @doc """
  Calls `callback` for each MetricFamily of this collector.
  """
  delegate collect_mf(registry \\ :default, collector, callback)
end
