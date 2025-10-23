{{- define "clickhouse.logger" -}}
{{- $mem := include "resource-bytes" (default (default (dict) .Values.resources.limits ).memory .Values.resources.requests.memory) }}
<logger>
    <level>{{ .Values.clickhouse.logLevel }}</level>
    <console>1</console>
    <size>1000M</size>
    <count>2</count>
    <log>/var/log/clickhouse/clickhouse-server.log</log>
    <errorlog>/var/log/clickhouse/clickhouse-server.err.log</errorlog>
</logger>
<query_log>
    <database>system</database>
    <table>query_log</table>
    <ttl>event_date + INTERVAL 7 DAY DELETE</ttl>
    <flush_interval_milliseconds>7500</flush_interval_milliseconds>
</query_log>
<query_views_log>
    <database>system</database>
    <table>query_views_log</table>
    <ttl>event_date + INTERVAL 7 DAY DELETE</ttl>
    <flush_interval_milliseconds>7500</flush_interval_milliseconds>
</query_views_log>
{{- if le (div $mem 1000000000) 4 }}
<query_metric_log remove="1" />
<text_log remove="1" />
<trace_log remove="1" />
<metric_log remove="1" />
<asynchronous_metric_log remove="1" />
{{- else }}
<query_metric_log>
    <database>system</database>
    <table>query_metric_log</table>
    <ttl>event_date + INTERVAL 7 DAY DELETE</ttl>
    <flush_interval_milliseconds>7500</flush_interval_milliseconds>
</query_metric_log>
{{- end }}
{{- end }}

{{- define "clickhouse.optimization" -}}
{{- $mem := include "resource-bytes" (default (default (dict) .Values.resources.limits ).memory .Values.resources.requests.memory) }}
{{- $memHalf := int64 (div (sub (int64 $mem) 1000000000) 2) }}
{{- if le (div $mem 1000000000) 2 -}}
<mark_cache_size>1073741824</mark_cache_size>
<max_server_memory_usage>0</max_server_memory_usage>
<max_server_memory_usage_to_ram_ratio>0.9</max_server_memory_usage_to_ram_ratio>
<merges_mutations_memory_usage_to_ram_ratio>0.8</merges_mutations_memory_usage_to_ram_ratio>
<background_pool_size>4</background_pool_size>
<merge_tree>
    <merge_max_block_size>256</merge_max_block_size>
    <max_parts_to_merge_at_once>1</max_parts_to_merge_at_once>
    <max_bytes_to_merge_at_min_space_in_pool>10485760</max_bytes_to_merge_at_min_space_in_pool>
    <max_bytes_to_merge_at_max_space_in_pool>{{ max 1073741824 $memHalf }}</max_bytes_to_merge_at_max_space_in_pool>
    <max_suspicious_broken_parts>100</max_suspicious_broken_parts>
    <min_merge_bytes_to_use_direct_io>10737418240</min_merge_bytes_to_use_direct_io>
    <number_of_free_entries_in_pool_to_lower_max_size_of_merge>2</number_of_free_entries_in_pool_to_lower_max_size_of_merge>
    <number_of_free_entries_in_pool_to_execute_mutation>5</number_of_free_entries_in_pool_to_execute_mutation>
    <number_of_free_entries_in_pool_to_execute_optimize_entire_partition>5</number_of_free_entries_in_pool_to_execute_optimize_entire_partition>
</merge_tree>
{{- else if le (div $mem 1000000000) 3 -}}
<mark_cache_size>1073741824</mark_cache_size>
<max_server_memory_usage_to_ram_ratio>0.8</max_server_memory_usage_to_ram_ratio>
<merge_tree>
    <merge_max_block_size>512</merge_max_block_size>
    <max_bytes_to_merge_at_max_space_in_pool>{{ max 1073741824 $memHalf }}</max_bytes_to_merge_at_max_space_in_pool>
    <max_suspicious_broken_parts>100</max_suspicious_broken_parts>
    <min_merge_bytes_to_use_direct_io>1073741824</min_merge_bytes_to_use_direct_io>
</merge_tree>
{{- else if le (div $mem 1000000000) 4 -}}
<mark_cache_size>1073741824</mark_cache_size>
<max_server_memory_usage_to_ram_ratio>0.8</max_server_memory_usage_to_ram_ratio>
<merge_tree>
    <merge_max_block_size>512</merge_max_block_size>
    <max_bytes_to_merge_at_max_space_in_pool>{{ $memHalf }}</max_bytes_to_merge_at_max_space_in_pool>
    <max_suspicious_broken_parts>100</max_suspicious_broken_parts>
    <min_merge_bytes_to_use_direct_io>1073741824</min_merge_bytes_to_use_direct_io>
</merge_tree>
{{- else if lt (div $mem 1000000000) 8 -}}
<mark_cache_size>1073741824</mark_cache_size>
<max_server_memory_usage_to_ram_ratio>0.8</max_server_memory_usage_to_ram_ratio>
<merge_tree>
    <merge_max_block_size>1024</merge_max_block_size>
    <max_bytes_to_merge_at_max_space_in_pool>{{ $memHalf }}</max_bytes_to_merge_at_max_space_in_pool>
    <max_suspicious_broken_parts>100</max_suspicious_broken_parts>
    <min_merge_bytes_to_use_direct_io>2147483648</min_merge_bytes_to_use_direct_io>
</merge_tree>
{{- else if lt (div $mem 1000000000) 16 -}}
<merge_tree>
    <merge_max_block_size>2048</merge_max_block_size>
    <max_suspicious_broken_parts>100</max_suspicious_broken_parts>
    <min_merge_bytes_to_use_direct_io>5368709120</min_merge_bytes_to_use_direct_io>
</merge_tree>
{{- else -}}
<merge_tree>
    <max_suspicious_broken_parts>100</max_suspicious_broken_parts>
</merge_tree>
{{- end }}
{{- end }}

{{- define "clickhouse.storage" -}}
<storage_configuration>
    <disks>
        {{- range $key, $val := .Values.storage.disks }}
        <{{ $key }}>
            {{- range $k, $v := $val }}
            {{- if not (has $k (list "backup")) }}
            <{{ $k }}>{{ $v }}</{{ $k }}>
            {{- end }}
            {{- end }}
        </{{ $key }}>
        {{- end }}
    </disks>
    <policies>
        {{- range $key, $val := .Values.storage.policies }}
        <{{ $key }}_policy>
            <volumes>
                <default>
                    <disk>{{ default "default" (get (default (dict) $val) "default_disk") }}</disk>
                </default>
                {{- if $val }}
                <{{ $key }}>
                    {{- range $k, $v := $val }}
                    {{- if not (has $k (list "move_factor" "default_disk" "backup")) }}
                    <{{ $k }}>{{ $v }}</{{ $k }}>
                    {{- end }}
                    {{- end }}
                </{{ $key }}>
                {{- end }}
            </volumes>
            {{- if $val }}
            <move_factor>{{ default "0.1" (get $val "move_factor") }}</move_factor>
            {{- end }}
        </{{ $key }}_policy>
        {{- end }}
    </policies>
</storage_configuration>
{{- end }}
