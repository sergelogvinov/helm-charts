{{/*
Expand the name of the chart.
*/}}
{{- define "mongodb-backup.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mongodb-backup.fullname" -}}
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
{{- define "mongodb-backup.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mongodb-backup.labels" -}}
helm.sh/chart: {{ include "mongodb-backup.chart" . }}
{{ include "mongodb-backup.selectorLabels" . }}
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
{{- define "mongodb-backup.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mongodb-backup.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mongodb-backup.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mongodb-backup.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the mongodb connection configuration
*/}}
{{- define "mongodb-backup.mongodb" -}}
mongodb://{{ .Values.auth.username }}:{{ .Values.auth.password }}@{{ .Values.auth.host }}
{{- end }}

{{/*
Create the mongodb connection configuration
*/}}
{{- define "mongodb-backup-localhost.mongodb" -}}
mongodb://{{ .Values.auth.username }}:{{ .Values.auth.password }}@localhost
{{- end }}

{{/*
Create the walg configuration
*/}}
{{- define "mongodb-backup.walg" -}}
WALG_COMPRESSION_METHOD: brotli

{{- if not .Values.walg }}
WALG_FILE_PREFIX: /backup
{{- else }}
{{ .Values.walg }}
{{- end }}

MONGODB_URI:                 '{{ include "mongodb-backup.mongodb" . }}'
WALG_STREAM_CREATE_COMMAND:  'mongodump --archive --oplog --uri="{{ include "mongodb-backup.mongodb" . }}"'
WALG_STREAM_RESTORE_COMMAND: 'mongorestore --archive --oplogReplay --uri="{{ include "mongodb-backup-localhost.mongodb" . }}"'
{{- end }}

{{/*
Create the walg backup-check configuration
*/}}
{{- define "mongodb-backup-check.walg" -}}
WALG_COMPRESSION_METHOD: brotli

{{- if not .Values.walg }}
WALG_FILE_PREFIX: /backup
{{- else }}
{{ .Values.walg }}
{{- end }}

MONGODB_URI:                 '{{ include "mongodb-backup-localhost.mongodb" . }}'
WALG_STREAM_CREATE_COMMAND:  'mongodump --archive --oplog --uri="{{ include "mongodb-backup.mongodb" . }}"'
WALG_STREAM_RESTORE_COMMAND: 'mongorestore --archive --oplogReplay --uri="{{ include "mongodb-backup-localhost.mongodb" . }}"'
{{- end }}
