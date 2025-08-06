<style>
/* chrome bug workaround */
.content-inner li pre{overflow: inherit;}
</style>
# Mnesia Collector
Collects Mnesia metrics mainly using
[:mnesia:system_info/1](http://erlang.org/doc/man/mnesia.html#system_info-1).

## Exported metrics

<ul>
  <li>
	<pre>erlang_mnesia_held_locks</pre>
    Type: gauge.<br/>
    Number of held locks.
  </li>
  <li>
    <pre>erlang_mnesia_lock_queue</pre>
    Type: gauge.<br/>
    Number of transactions waiting for a lock.
  </li>
  <li>
    <pre>erlang_mnesia_transaction_participants</pre>
    Type: gauge.<br/>
    Number of participant transactions.
  </li>
  <li>
    <pre>erlang_mnesia_transaction_coordinators</pre>
    Type: gauge.<br/>
    Number of coordinator transactions.
  </li>
  <li>
    <pre>erlang_mnesia_failed_transactions_total</pre>
    Type: counter.<br/>
    Number of failed (i.e. aborted) transactions.
  </li>
  <li>
    <pre>erlang_mnesia_committed_transactions_total</pre>
    Type: gauge.<br/>
    Number of committed transactions.
  </li>
  <li>
    <pre>erlang_mnesia_logged_transactions_total</pre>
    Type: counter.<br/>
    Number of transactions logged.
  </li>
  <li>
    <pre>erlang_mnesia_restarted_transactions_total</pre>
    Type: counter.<br/>
    Total number of transaction restarts.
  </li>
</ul>

## Configuration

Metrics exported by this collector can be configured via
`mnesia_collector_metrics` key of `prometheus` app environment.

Available options:
 - `:held_locks` for `erlang_mnesia_held_locks`;
 - `:lock_queue` for `erlang_mnesia_lock_queue`;
 - `:transaction_participants` for `erlang_mnesia_transaction_participants`;
 - `:transaction_coordinators` for `erlang_mnesia_transaction_coordinators`;
 - `:transaction_failures` for `erlang_mnesia_failed_transactions_total`;
 - `:transaction_commits` for `erlang_mnesia_committed_transactions_total`;
 - `:transaction_log_writes` for `erlang_mnesia_logged_transactions_total`;
 - `:transaction_restarts` for `erlang_mnesia_restarted_transactions_total`.

By default all metrics are enabled.
