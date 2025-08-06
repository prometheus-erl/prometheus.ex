<style>
/* chrome bug workaround */
.content-inner li pre{overflow: inherit;}
</style>
# VM Memory Collector
Collects information about memory dynamically allocated
by the Erlang emulator using
[:erlang.memory/0](http://erlang.org/doc/man/erlang.html#memory-0).
Also provides basic (D)ETS statistics.

## Exported metrics

<ul>
  <li>
    <pre>erlang_vm_memory_atom_bytes</pre>
	Type: gauge.<br/>
    Labels:
    <ul style="list-style:circle">
      <li>usage="free"|"used".</li>
    </ul>
    <br/>
    The total amount of memory currently allocated for atoms.
    This memory is part of the memory presented as system memory.
  </li>
  <li>
    <pre>erlang_vm_memory_bytes</pre>
	Type: gauge.<br/>
    Labels:
    <ul style="list-style:circle">
      <li>kind="system"|"processes".</li>
    </ul>
    <br/>
    The total amount of memory currently allocated.
    This is the same as the sum of the memory size for processes and system.
  </li>
  <li>
    <pre>erlang_vm_dets_tables</pre>
	Type: gauge.<br/>
    Erlang VM DETS Tables count.
  </li>
  <li>
    <pre>erlang_vm_ets_tables</pre>
	Type: gauge.<br/>
    Erlang VM ETS Tables count.
  </li>
  <li>
    <pre>erlang_vm_memory_processes_bytes</pre>
	Type: gauge.<br/>
    Labels:
    <ul style="list-style:circle">
      <li>usage="used"|"free".</li>
    </ul>
    <br/>
    The total amount of memory currently allocated for the Erlang processes.
  </li>
  <li>
    <pre>erlang_vm_memory_system_bytes</pre>
	Type: gauge.<br/>
    Labels:
    <ul style="list-style:circle">
      <li>usage="atom"|"binary"|"code"|"ets"|"other".</li>
    </ul>
    <br/>
    The total amount of memory currently allocated for the emulator
    that is not directly related to any Erlang process.
    Memory presented as processes is not included in this memory.
  </li>
</ul>

## Configuration

Metrics exported by this collector can be configured via
`:vm_memory_collector_metrics` key of `:prometheus` app environment.

Available options:
 - `:atom_bytes_total` for `erlang_vm_memory_atom_bytes`;
 - `:bytes_total` for `erlang_vm_memory_bytes`;
 - `:dets_tables` for `erlang_vm_dets_tables`;
 - `:ets_tables` for `erlang_vm_ets_tables`;
 - `:processes_bytes_total` for `erlang_vm_memory_processes_bytes`;
 - `:system_bytes_total` for `erlang_vm_memory_system_bytes`.

By default all metrics are enabled.
