defmodule Prometheus.SummaryTest do
  use Prometheus.Case

  test "registration" do
    spec = [name: :name, help: "", registry: :qwe]

    assert true == Summary.declare(spec)
    assert false == Summary.declare(spec)

    assert_raise Prometheus.MFAlreadyExistsError, "Metric qwe:name already exists.", fn ->
      Summary.new(spec)
    end
  end

  test "spec errors" do
    assert_raise Prometheus.MissingMetricSpecKeyError,
                 "Required key name is missing from metric spec.",
                 fn ->
                   Summary.new(help: "")
                 end

    assert_raise Prometheus.InvalidMetricNameError, "Invalid metric name: 12.", fn ->
      Summary.new(name: 12, help: "")
    end

    assert_raise Prometheus.InvalidMetricLabelsError, "Invalid metric labels: 12.", fn ->
      Summary.new(name: "qwe", labels: 12, help: "")
    end

    assert_raise Prometheus.InvalidMetricHelpError, "Invalid metric help: 12.", fn ->
      Summary.new(name: "qwe", help: 12)
    end
  end

  test "summary specific errors" do
    spec = [name: :http_requests_total, help: ""]

    ## observe
    assert_raise Prometheus.InvalidValueError,
                 "Invalid value: \"qwe\" (observe accepts only numbers).",
                 fn ->
                   Summary.observe(spec, "qwe")
                 end

    ## observe_duration TODO: assert_compile_time_raise
    assert_raise Prometheus.InvalidBlockArityError,
                 "Fn with arity 2 (args: :x, :y) passed as block.",
                 fn ->
                   Macro.expand(
                     quote do
                       Summary.observe_duration(spec, fn x, y -> 1 + x + y end)
                     end,
                     __ENV__
                   )
                 end
  end

  test "mf/arity errors" do
    spec = [name: :metric_with_label, labels: [:label], help: ""]
    Summary.declare(spec)

    ## observe
    assert_raise Prometheus.UnknownMetricError,
                 "Unknown metric {registry: default, name: unknown_metric}.",
                 fn ->
                   Summary.observe(:unknown_metric, 1)
                 end

    assert_raise Prometheus.InvalidMetricArityError,
                 "Invalid metric arity: got 2, expected 1.",
                 fn ->
                   Summary.observe([name: :metric_with_label, labels: [:l1, :l2]], 1)
                 end

    ## observe_duration
    assert_raise Prometheus.UnknownMetricError,
                 "Unknown metric {registry: default, name: unknown_metric}.",
                 fn ->
                   Summary.observe_duration(:unknown_metric, fn -> 1 end)
                 end

    assert_raise Prometheus.InvalidMetricArityError,
                 "Invalid metric arity: got 2, expected 1.",
                 fn ->
                   Summary.observe_duration(
                     [name: :metric_with_label, labels: [:l1, :l2]],
                     fn -> 1 end
                   )
                 end

    ## remove
    assert_raise Prometheus.UnknownMetricError,
                 "Unknown metric {registry: default, name: unknown_metric}.",
                 fn ->
                   Summary.remove(:unknown_metric)
                 end

    assert_raise Prometheus.InvalidMetricArityError,
                 "Invalid metric arity: got 2, expected 1.",
                 fn ->
                   Summary.remove(name: :metric_with_label, labels: [:l1, :l2])
                 end

    ## reset
    assert_raise Prometheus.UnknownMetricError,
                 "Unknown metric {registry: default, name: unknown_metric}.",
                 fn ->
                   Summary.reset(:unknown_metric)
                 end

    assert_raise Prometheus.InvalidMetricArityError,
                 "Invalid metric arity: got 2, expected 1.",
                 fn ->
                   Summary.reset(name: :metric_with_label, labels: [:l1, :l2])
                 end

    ## value
    assert_raise Prometheus.UnknownMetricError,
                 "Unknown metric {registry: default, name: unknown_metric}.",
                 fn ->
                   Summary.value(:unknown_metric)
                 end

    assert_raise Prometheus.InvalidMetricArityError,
                 "Invalid metric arity: got 2, expected 1.",
                 fn ->
                   Summary.value(name: :metric_with_label, labels: [:l1, :l2])
                 end
  end

  test "observe" do
    spec = [name: :http_requests_total, labels: [:method], help: ""]
    Summary.new(spec)

    Summary.observe(spec)
    Summary.observe(spec, 3)
    Summary.observe(spec)
    Summary.observe(spec, 3.5)

    assert {4, 8.5} == Summary.value(spec)

    Summary.reset(spec)

    assert {0, 0} == Summary.value(spec)
  end

  test "observe_duration fn" do
    spec = [name: :duration_seconds, labels: [:method], help: ""]
    Summary.new(spec)

    assert 1 ==
             Summary.observe_duration(spec, fn ->
               Process.sleep(1000)
               1
             end)

    ## observe_duration is async. let's make sure gen_server processed our request
    Process.sleep(10)
    {count, sum} = Summary.value(spec)
    assert 1 == count
    assert 1 < sum and sum < 1.2

    assert_raise ErlangError, fn ->
      Summary.observe_duration(spec, fn ->
        :erlang.error({:qwe})
      end)
    end

    ## observe_duration is async. let's make sure gen_server processed our request
    Process.sleep(10)
    {count, sum} = Summary.value(spec)
    assert 2 == count
    assert 1 < sum and sum < 1.2
  end

  test "observe_duration block" do
    spec = [name: :duration_seconds, labels: [:method], help: ""]
    Summary.new(spec)

    assert :ok == Summary.observe_duration(spec, do: Process.sleep(1000))

    ## observe_duration is async. let's make sure gen_server processed our request
    Process.sleep(10)
    {count, sum} = Summary.value(spec)
    assert 1 == count
    assert 1 < sum and sum < 1.2

    assert_raise ErlangError, fn ->
      Summary.observe_duration spec do
        :erlang.error({:qwe})
      end
    end

    ## observe_duration is async. let's make sure gen_server processed our request
    Process.sleep(10)
    {count, sum} = Summary.value(spec)
    assert 2 == count
    assert 1 < sum and sum < 1.2
  end

  test "remove" do
    spec = [name: :http_requests_total, labels: [:method], help: ""]
    wl_spec = [name: :simple_summary, help: ""]

    Summary.new(spec)
    Summary.new(wl_spec)

    Summary.observe(spec)
    Summary.observe(wl_spec)

    assert {1, 1} == Summary.value(spec)
    assert {1, 1} == Summary.value(wl_spec)

    assert true == Summary.remove(spec)
    assert true == Summary.remove(wl_spec)

    assert :undefined == Summary.value(spec)
    assert :undefined == Summary.value(wl_spec)

    assert false == Summary.remove(spec)
    assert false == Summary.remove(wl_spec)
  end

  test "undefined value" do
    lspec = [name: :orders_summary, labels: [:department], help: ""]
    Summary.new(lspec)

    assert :undefined == Summary.value(lspec)

    spec = [name: :something_summary, labels: [], help: ""]
    Summary.new(spec)

    assert {0, 0} == Summary.value(spec)
  end
end
