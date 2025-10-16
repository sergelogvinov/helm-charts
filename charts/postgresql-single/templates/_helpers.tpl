{{/*
Expand the name of the chart.
*/}}
{{- define "postgresql-single.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "postgresql-single.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "postgresql-single.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "postgresql-single.labels" -}}
helm.sh/chart: {{ include "postgresql-single.chart" . }}
{{ include "postgresql-single.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "postgresql-single.crontab.labels" -}}
helm.sh/chart: {{ include "postgresql-single.chart" . }}
{{ include "postgresql-single.crontab.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "postgresql-single.selectorLabels" -}}
app.kubernetes.io/name: {{ include "postgresql-single.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Selector labels cnpg
*/}}
{{- define "postgresql-single.selectorLabels.cnpg" -}}
cnpg.io/cluster: {{ include "postgresql-single.fullname" . }}
{{- end }}

{{- define "postgresql-single.crontab.selectorLabels" -}}
app.kubernetes.io/name: {{ include "postgresql-single.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}-crontab
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "postgresql-single.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "postgresql-single.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Convert a memory resource like "500Mi" to the number 500
*/}}
{{- define "resource-megabytes" -}}
{{- if . | hasSuffix "Mi" -}}
{{- . | trimSuffix "Mi" | int64 -}}
{{- else if . | hasSuffix "Gi" -}}
{{- mulf (. | trimSuffix "Gi" | int64) 1024 | int64 -}}
{{- else if . | hasSuffix "Ti" -}}
{{- mulf (. | trimSuffix "Ti" | int64) 1048576 | int64 -}}
{{- else -}}
1024 | int64
{{- end }}
{{- end }}

{{/*
Convert a cpu resource like "500m" to the number 1
*/}}
{{- define "resource-cpu" -}}
{{- if . | printf "%s" | hasSuffix "m" -}}
{{- max 1 (int (div (. | trimSuffix "m" | int) 1000)) -}}
{{- else -}}
{{- max 1 (int .) -}}
{{- end }}
{{- end }}

{{/*
Return a soft podAffinity/podAntiAffinity definition
*/}}
{{- define "affinities.pods.soft" -}}
preferredDuringSchedulingIgnoredDuringExecution:
  - podAffinityTerm:
      labelSelector:
        matchLabels: {{- (include "postgresql-single.selectorLabels" .) | nindent 10 }}
      namespaces:
        - {{ .Release.Namespace | quote }}
      topologyKey: {{ .Values.podAntiAffinityPresetKey }}
    weight: 1
{{- end -}}

{{/*
Return a hard podAffinity/podAntiAffinity definition
*/}}
{{- define "affinities.pods.hard" -}}
requiredDuringSchedulingIgnoredDuringExecution:
  - labelSelector:
      matchLabels: {{- (include "postgresql-single.selectorLabels" .) | nindent 8 }}
    namespaces:
      - {{ .Release.Namespace | quote }}
    topologyKey: {{ .Values.podAntiAffinityPresetKey }}
{{- end -}}


{{/*
Return a podAffinity/podAntiAffinity definition
*/}}
{{- define "affinities.pods" -}}
  {{- if eq .Values.podAntiAffinityPreset "soft" }}
    {{- include "affinities.pods.soft" . -}}
  {{- else if eq .Values.podAntiAffinityPreset "hard" }}
    {{- include "affinities.pods.hard" . -}}
  {{- end -}}
{{- end -}}

{{/*
Create the postgresqlPassword
*/}}
{{- define "postgresql-single.postgresqlPassword" -}}
{{- $sname := include "postgresql-single.fullname" . }}
{{- $previous := lookup "v1" "Secret" .Release.Namespace $sname }}
{{- if .Values.postgresqlPassword }}
{{- .Values.postgresqlPassword }}
{{- else if $previous }}
{{- default (randAlphaNum 16) ($previous.data.postgresqlPassword | b64dec ) }}
{{- else }}
{{- randAlphaNum 16 }}
{{- end }}
{{- end }}

{{/*
Create the postgresql primary service selector
*/}}
{{- define "postgresql-single.primary" -}}
{{- $sname := include "postgresql-single.fullname" . }}
{{- $previous := lookup "v1" "Service" .Release.Namespace $sname }}
{{- if $previous }}
{{- default (printf "%s-0" $sname) (get $previous.spec.selector "statefulset.kubernetes.io/pod-name") -}}
{{- else }}
{{- printf "%s-0" $sname -}}
{{- end }}
{{- end }}

{{/*
Create the postgresql folover service selector
*/}}
{{- define "postgresql-single.folover-number" -}}
{{- $pname := include "postgresql-single.primary" . }}
{{- if le (int .Values.replicaCount) 1 }}
{{- 0 -}}
{{- else if eq $pname (printf "%s-0" (include "postgresql-single.fullname" .)) }}
{{- sub (int .Values.replicaCount) 1 -}}
{{- else }}
{{- 0 -}}
{{- end }}
{{- end }}

{{- define "postgresql-single.postgresqlConninfoDict" -}}
{{- $res := dict -}}
{{- $keysVal := splitList " " (tpl .Values.postgresqlConninfo .) -}}
{{- range $i, $key := $keysVal -}}
{{- $kv := splitList "=" $key -}}
{{- if eq (len $kv) 2 -}}
{{- $res = merge $res (dict (index $kv 0) (index $kv 1)) -}}
{{- end -}}
{{- end -}}
{{- $res | toYaml }}
{{- end }}

{{/*
Create the postgresqlConfiguration
*/}}
{{- define "postgresql-single.postgresqlConfiguration" -}}
{{- if not .Values.postgresqlConfiguration }}
{{- $size := include "resource-megabytes" (default "10Gi" .Values.persistence.size) }}
{{- $cpu := include "resource-cpu" (default .Values.resources.requests.cpu (get (default (dict) .Values.resources.limits) "cpu")) }}
listen_addresses = '*'

lc_messages = 'en_US.UTF-8'
lc_monetary = 'en_US.UTF-8'
lc_numeric = 'en_US.UTF-8'
lc_time = 'en_US.UTF-8'

# Connectivity
max_connections = {{ .Values.postgresqlMaxConnections }}
superuser_reserved_connections = 5

ssl = on
ssl_max_protocol_version = TLSv1.3
ssl_min_protocol_version = TLSv1.2
ssl_ciphers = 'EECDH+AESGCM:EDH+AESGCM'
ssl_prefer_server_ciphers = on
ssl_ecdh_curve = 'prime256v1'
ssl_cert_file = '/etc/ssl/tlscerts/tls.crt'
ssl_key_file = '/etc/ssl/tlscerts/tls.key'
{{- if .Values.tlsCerts.create }}
ssl_ca_file = '/etc/ssl/tlscerts/ca.crt'
{{- end }}
ssl_crl_file = ''

tcp_keepalives_idle = 600
tcp_keepalives_interval = 75
tcp_keepalives_count = 10

shared_preload_libraries = 'pg_stat_statements'
track_io_timing = on
pg_stat_statements.max = 1000
pg_stat_statements.track = all

full_page_writes = on
wal_level = replica
wal_compression = on
wal_buffers = -1
{{- if .Values.postgresqlServerWalWriterDelay }}
wal_writer_delay = {{ .Values.postgresqlServerWalWriterDelay }}
wal_writer_flush_after = 1MB
{{- end }}
{{- if ge (int64 $size) (int64 512000) }}
wal_keep_size = {{ div $size 32 }}MB
{{- else }}
wal_keep_size = {{ div $size 10 }}MB
{{- end }}

max_replication_slots = 10
max_wal_senders = 10
max_wal_size = 10240MB
{{- if ge (int64 $size) (int64 1024000) }}
min_wal_size = 5120MB
{{- else }}
min_wal_size = 512MB
{{- end }}
{{- if ge (int64 $size) (int64 100000) }}
max_slot_wal_keep_size = {{ div $size 10 }}MB
{{- end }}

# Checkpointing:
checkpoint_timeout  = 15min
checkpoint_completion_target = 0.9

# Background writer
bgwriter_delay = 200ms
bgwriter_lru_maxpages = 100
bgwriter_lru_multiplier = 2.0
bgwriter_flush_after = 0

{{- if ge (int $cpu) 2 }}

# Parallel queries:
max_worker_processes = {{ $cpu }}
max_parallel_workers = {{ $cpu }}
max_parallel_workers_per_gather = {{ max 1 (div $cpu 2) }}
max_parallel_maintenance_workers = {{ max 1 (div $cpu 2) }}
parallel_leader_participation = on
{{- end }}

# Advanced features
enable_partitionwise_join = on
enable_partitionwise_aggregate = on
jit = on
{{- else }}
{{ .Values.postgresqlConfiguration }}
{{- end }}
{{- end }}

{{- define "postgresql-single.postgresqlConfigurationReplication" -}}
# Replication
hot_standby = on
archive_mode = on
{{- if or .Values.backup.enabled .Values.backup.recovery }}
{{- if .Values.backup.walpush }}
archive_timeout = 30min
archive_command = '/usr/bin/wal-g --config /etc/walg/walg.yaml wal-push %p'
{{- else }}
archive_command = '/bin/true'
{{- end }}
{{- if .Values.backup.recovery }}
restore_command = '/usr/bin/wal-g --config /etc/walg/walg.yaml wal-fetch %f %p'
{{- end }}
{{- else }}
archive_command = '/bin/true'
{{- end }}
{{- end }}

{{- define "postgresql-single.postgresqlConfigurationOptimization" -}}
# auto generated, see https://pgconfigurator.cybertec.at
work_mem = {{ div .Values.postgresqlServerMemory 32 }}MB
maintenance_work_mem = {{ div .Values.postgresqlServerMemory 4 }}MB
effective_cache_size = {{ div .Values.postgresqlServerMemory 2 }}MB
effective_io_concurrency = 100
random_page_cost = 1.25
{{- if and .Values.resources.requests (hasKey .Values.resources.requests "hugepages-1Gi") }}
{{- $pages := int (regexFind "[0-9]+" (get .Values.resources.requests "hugepages-1Gi")) }}
shared_buffers = {{ sub $pages 1 }}GB
huge_pages = try
{{- else if and .Values.resources.requests (hasKey .Values.resources.requests "hugepages-2Mi") }}
{{- $pages := int (include "resource-megabytes" (get .Values.resources.requests "hugepages-2Mi")) }}
shared_buffers = {{ sub $pages 800 }}MB
huge_pages = try
{{- else }}
shared_buffers = {{ div .Values.postgresqlServerMemory 4 }}MB
huge_pages = off
{{- end }}
{{- end }}

{{/*
Create the postgresqlConfigurationLogs
*/}}
{{- define "postgresql-single.postgresqlConfigurationLogs" -}}
{{- if not .Values.postgresqlConfigurationLogs }}
log_timezone = 'UTC'
log_checkpoints = on
log_connections = off
log_disconnections = off
log_duration = off
log_error_verbosity = default
log_hostname = off
log_line_prefix = '%t [%p]: user=%u,db=%d,app=%a '
log_lock_waits = on
log_statement = 'none'
log_temp_files = -1
log_min_duration_statement = 10000
log_autovacuum_min_duration = 1000

logging_collector = off
log_destination = 'stderr'
log_directory = '{{ .Values.persistence.mountPath }}'
log_filename = 'postgresql-%a.log'
log_truncate_on_rotation = on
log_rotation_age = 1440
log_rotation_size = 0
{{- else }}
{{ .Values.postgresqlConfigurationLogs }}
{{- end }}
{{- end }}

{{/*
Set DATA_SOURCE_URI environment variable
*/}}
{{- define "postgresql-single.data_source_uri" -}}
{{ printf "127.0.0.1:5432/%s?sslmode=disable" .Values.metrics.database | quote }}
{{- end }}

{{/*
Create the walg configuration
*/}}
{{- define "postgresql-single.walg" -}}
{{- if not .Values.backup.walg }}
WALG_TAR_SIZE_THRESHOLD: 274877906944
WALG_TAR_DISABLE_FSYNC: true
WALG_UPLOAD_WAL_METADATA: INDIVIDUAL
WALG_PREVENT_WAL_OVERWRITE: true
WALG_COMPRESSION_METHOD: brotli
WALG_DELTA_MAX_STEPS: 1
WALG_FILE_PREFIX: {{ .Values.persistence.mountPath }}/backup
{{- else if eq .Values.installationType "cnpg" }}
{{- $version := semver (default .Chart.AppVersion .Values.image.tag) }}
{{- $walg := deepCopy .Values.backup.walg }}
WALG_S3_PREFIX: {{ get .Values.backup.walg "WALG_S3_PREFIX" }}/{{ $version.Major }}
{{ unset $walg "WALG_S3_PREFIX" | toYaml }}
{{- else }}
{{- .Values.backup.walg | toYaml }}
{{- end }}
{{- end }}
