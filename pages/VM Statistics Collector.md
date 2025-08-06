<style>
/* chrome bug workaround */
.content-inner li pre{overflow: inherit;}
</style>
# VM Statistics Collector
Collects Erlang VM metrics using
[:erlang.statistics/1](http://erlang.org/doc/man/erlang.html#statistics-1).

## Exported metrics

<ul>
  <li>
    <pre>erlang_vm_statistics_bytes_output_total</pre>
	Type: counter.<br/>
    The total number of bytes output to ports.
  </li>
  <li>
    <pre>erlang_vm_statistics_bytes_received_total</pre>
	Type: counter.<br/>
    The total number of bytes received through ports.
  </li>
  <li>
    <pre>erlang_vm_statistics_context_switches_total</pre>
	Type: counter.<br/>
    The total number of context switches since the system started.
  </li>
  <li>
    <pre>erlang_vm_statistics_garbage_collection_number_of_gcs_total</pre>
	Type: counter.<br/>
    The total number of garbage collections since the system started.
  </li>
  <li>
    <pre>erlang_vm_statistics_garbage_collection_words_reclaimed_total</pre>
	Type: counter.<br/>
    The total number of words reclaimed by GC since the system started.
  </li>
  <li>
    <pre>erlang_vm_statistics_garbage_collection_bytes_reclaimed_total</pre>
	Type: counter.<br/>
    The total number of bytes reclaimed by GC since the system started.
  </li>
  <li>
    <pre>erlang_vm_statistics_reductions_total</pre>
	Type: counter.<br/>
    Total reductions count.
  </li>
  <li>
    <pre>erlang_vm_statistics_run_queues_length_total</pre>
	Type: gauge.<br/>
    The total length of the run-queues. That is, the number of
    processes and ports that are ready to run on all available run-queues.
  </li>
  <li>
    <pre>erlang_vm_statistics_runtime_seconds_total</pre>
	Type: counter.<br/>
    The sum of the runtime for all threads in the Erlang runtime system.
  </li>
  <li>
    <pre>erlang_vm_statistics_wallclock_time_seconds_total</pre>
	Type: counter.<br/>
    Can be used in the same manner as
    <code class="inline">erlang_vm_statistics_runtime_seconds_total</code>,
	except that real time is measured as opposed to runtime or CPU time.
  </li>
</ul>

## Configuration

Metrics exported by this collector can be configured via
`:vm_statistics_collector_metrics` key of `:prometheus` app environment.

Options are the same as Item parameter values for
[:erlang.statistics/1](http://erlang.org/doc/man/erlang.html#statistics-1):
 - `:context_switches` for `erlang_vm_statistics_context_switches_total`;
 - `:garbage_collection`
   for `erlang_vm_statistics_garbage_collection_number_of_gcs_total`,
   `:erlang_vm_statistics_garbage_collection_bytes_reclaimed_total`, and
   `:erlang_vm_statistics_garbage_collection_words_reclaimed_total`;
 - `:io` for `erlang_vm_statistics_bytes_output_total` and
    `erlang_vm_statistics_bytes_received_total`;
 - `:reductions` for `erlang_vm_statistics_reductions_total`;
 - `:run_queue` for `erlang_vm_statistics_run_queues_length_total`;
 - `:runtime` for `erlang_vm_statistics_runtime_seconds_total`;
 - `:wall_clock` for `erlang_vm_statistics_wallclock_time_seconds_total`.

By default all metrics are enabled.
