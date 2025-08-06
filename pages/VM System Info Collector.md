<style>
/* chrome bug workaround */
.content-inner li pre{overflow: inherit;}
</style>
# VM System Information Collector
Collects Erlang VM metrics using
[:erlang.system_info/1](http://erlang.org/doc/man/erlang.html#system_info-1).

## Exported metrics

<ul>
  <li>
    <pre>erlang_vm_ets_limit</pre>
	Type: gauge.<br/>
    The maximum number of ETS tables allowed.
  </li>
  <li>
    <pre>erlang_vm_logical_processors</pre>
	Type: gauge.<br/>
    The detected number of logical processors configured in the system.
  </li>
  <li>
    <pre>erlang_vm_logical_processors_available</pre>
	Type: gauge.<br/>
    The detected number of logical processors
    available to the Erlang runtime system.
  </li>
  <li>
    <pre>erlang_vm_logical_processors_online</pre>
	Type: gauge.<br/>
    The detected number of logical processors online on the system.
  </li>
  <li>
    <pre>erlang_vm_ports</pre>
	Type: gauge.<br/>
    The number of ports currently existing at the local node.
  </li>
  <li>
    <pre>erlang_vm_port_limit</pre>
	Type: gauge.<br/>
    The maximum number of simultaneously existing ports at the local node.
  </li>
  <li>
    <pre>erlang_vm_processes</pre>
	Type: gauge.<br/>
    The number of processes currently existing at the local node.
  </li>
  <li>
    <pre>erlang_vm_process_limit</pre>
	Type: gauge.<br/>
    The maximum number of simultaneously existing processes
    at the local node.
  </li>
  <li>
    <pre>erlang_vm_schedulers</pre>
	Type: gauge.<br/>
    The number of scheduler threads used by the emulator.
  </li>
  <li>
    <pre>erlang_vm_schedulers_online</pre>
	Type: gauge.<br/>
    The number of schedulers online.
  </li>
  <li>
    <pre>erlang_vm_smp_support</pre>
	Type: boolean.<br/>
    1 if the emulator has been compiled with SMP support, otherwise 0.
  </li>
  <li>
    <pre>erlang_vm_threads</pre>
	Type: boolean.<br/>
    1 if the emulator has been compiled with thread support, otherwise 0.
  </li>
  <li>
    <pre>erlang_vm_thread_pool_size</pre>
	Type: gauge.<br/>
    The number of async threads in the async thread pool
    used for asynchronous driver calls.
  </li>
  <li>
    <pre>erlang_vm_time_correction</pre>
	Type: boolean.<br/>
    1 if time correction is enabled, otherwise 0.
  </li>
</ul>

## Configuration

Metrics exported by this collector can be configured via
`:vm_system_info_collector_metrics` key of `:prometheus` app environment.

Options are the same as Item parameter values for
[:erlang.system_info/1](http://erlang.org/doc/man/erlang.html#system_info-1):
 - `:ets_limit` for `erlang_vm_ets_limit`;
 - `:logical_processors` for `erlang_vm_logical_processors`;
 - `:logical_processors_available` for
    `erlang_vm_logical_processors_available`;
 - `:logical_processors_online` for `erlang_vm_logical_processors_online`;
 - `:port_count` for `erlang_vm_ports`;
 - `:port_limit` for `erlang_vm_port_limit`;
 - `:process_count` for `erlang_vm_processes`;
 - `:process_limit` for `erlang_vm_process_limit`;
 - `:schedulers` for `erlang_vm_schedulers`;
 - `:schedulers_online` for `erlang_vm_schedulers_online`;
 - `:smp_support` for `erlang_vm_smp_support`;
 - `:threads` for `erlang_threads`;
 - `:thread_pool_size` for `erlang_vm_thread_pool_size`;
 - `:time_correction` for `erlang_vm_time_correction`.
By default all metrics are enabled.
