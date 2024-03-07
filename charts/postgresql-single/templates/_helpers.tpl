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
{{- mulf (. | trimSuffix "Gi" | int64) 1024 -}}
{{- else -}}
1024
{{- end }}
{{- end }}

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
Create the postgresqlConfiguration
*/}}
{{- define "postgresql-single.postgresqlConfiguration" -}}
{{- if not .Values.postgresqlConfiguration }}
listen_addresses = '*'

lc_messages = 'en_US.UTF-8'
lc_monetary = 'en_US.UTF-8'
lc_numeric = 'en_US.UTF-8'
lc_time = 'en_US.UTF-8'
log_timezone = 'UTC'

# Connectivity
max_connections = {{ .Values.postgresqlMaxConnections }}
superuser_reserved_connections = 5

ssl = on
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
wal_writer_delay = 200ms
wal_writer_flush_after = 1MB

max_replication_slots = 8
max_wal_senders = 8
max_wal_size = 10240MB
min_wal_size = 512MB

# Checkpointing:
checkpoint_timeout  = 15min
checkpoint_completion_target = 0.9

# Background writer
bgwriter_delay = 200ms
bgwriter_lru_maxpages = 100
bgwriter_lru_multiplier = 2.0
bgwriter_flush_after = 0

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

{{- else }}
{{ .Values.postgresqlConfiguration }}
{{- end }}
{{- end }}

{{/*
Create the postgresqlConfigurationLogs
*/}}
{{- define "postgresql-single.postgresqlConfigurationLogs" -}}
{{- if not .Values.postgresqlConfigurationLogs }}
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
{{- else }}
{{- .Values.backup.walg | toYaml }}
{{- end }}
{{- end }}
