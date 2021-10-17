{{/*
Expand the name of the chart.
*/}}
{{- define "keydb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "keydb.fullname" -}}
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
{{- define "keydb.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "keydb.labels" -}}
helm.sh/chart: {{ include "keydb.chart" . }}
{{ include "keydb.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.podLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{- define "keydb.crontab.labels" -}}
helm.sh/chart: {{ include "keydb.chart" . }}
{{ include "keydb.crontab.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.podLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "keydb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "keydb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "keydb.crontab.selectorLabels" -}}
app.kubernetes.io/name: {{ include "keydb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}-crontab
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "keydb.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "keydb.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Common port
*/}}
{{- define "keydb.port" -}}
{{- if .Values.tlsCerts.create }}
{{- "6380" }}
{{- else }}
{{- "6379" }}
{{- end }}
{{- end }}

{{/*
Common config
*/}}
{{- define "keydb.commonConfig" -}}
bind 0.0.0.0 -::
port 6379
{{- if .Values.tlsCerts.create }}
tls-port 6380
tls-replication yes
tls-cluster yes

tls-cert-file /etc/ssl/tlscerts/tls.crt
tls-key-file /etc/ssl/tlscerts/tls.key
tls-ca-cert-file /etc/ssl/tlscerts/ca.crt
tls-protocols "TLSv1.2 TLSv1.3"
tls-ciphers "DEFAULT:!MEDIUM"
tls-ciphersuites TLS_CHACHA20_POLY1305_SHA256
tls-prefer-server-ciphers yes

cluster-announce-port 6379
cluster-announce-tls-port 6380
{{- end }}

tcp-backlog 511
tcp-keepalive 300

maxclients 1024

server-threads {{ .Values.keydb.threads | int }}
active-replica {{ .Values.keydb.activeReplica }}
multi-master {{ .Values.keydb.multiMaster }}

loglevel notice
logfile ""

{{- if .Values.keydb.password }}
masterauth "{{ .Values.keydb.password  }}"
requirepass "{{ .Values.keydb.password  }}"
{{- end }}

save 900 1
save 60  100000

dir /data
dbfilename keydb.rdb

stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes

maxmemory-policy noeviction
{{- end }}

{{/*
Backup wal-g config
*/}}
{{- define "keydb.walgYaml" -}}
{{- if not .Values.backup.walg }}
WALG_COMPRESSION_METHOD: brotli
WALG_DELTA_MAX_STEPS: 4
WALG_FILE_PREFIX: /data
WALG_STREAM_CREATE_COMMAND: "/usr/local/bin/redis-cli -h {{ include "keydb.fullname" . }} --rdb -"
WALG_STREAM_RESTORE_COMMAND: "cat > /data/dump.rdb"
{{- if .Values.keydb.password }}
WALG_REDIS_PASSWORD: "{{ .Values.keydb.password  }}"
{{- end }}
{{- else }}
{{ .Values.backup.walg }}
{{- end }}
{{- end }}
