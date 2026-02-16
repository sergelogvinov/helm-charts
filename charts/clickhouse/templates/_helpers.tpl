{{/*
Expand the name of the chart.
*/}}
{{- define "clickhouse.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "clickhouse.fullname" -}}
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

{{- define "clickhouse.podfullname" -}}
{{- if eq .Values.installationType "altinity" }}
{{- printf "chi-clickhouse-%s" (include "clickhouse.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- include "clickhouse.fullname" . }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "clickhouse.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "clickhouse.labels" -}}
helm.sh/chart: {{ include "clickhouse.chart" . }}
{{ include "clickhouse.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "clickhouse.crontab.labels" -}}
helm.sh/chart: {{ include "clickhouse.chart" . }}
{{ include "clickhouse.crontab.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "clickhouse.selectorLabels" -}}
app.kubernetes.io/name: {{ include "clickhouse.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "clickhouse.crontab.selectorLabels" -}}
app.kubernetes.io/name: {{ include "clickhouse.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}-crontab
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "clickhouse.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "clickhouse.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the backupPassword
*/}}
{{- define "clickhouse.backupPassword" -}}
{{- $sname := include "clickhouse.fullname" . }}
{{- $previous := lookup "v1" "Secret" .Release.Namespace $sname }}
{{- if .Values.backup.backupPassword }}
{{- .Values.backup.backupPassword }}
{{- else if and $previous $previous.data.backupPassword }}
{{- default (randAlphaNum 16) ($previous.data.backupPassword | b64dec ) }}
{{- else }}
{{- randAlphaNum 16 }}
{{- end }}
{{- end }}

{{/*
Convert a memory resource like "500Mi" to the number 500000000 (bytes)
*/}}
{{- define "resource-bytes" -}}
{{- if . | hasSuffix "Mi" -}}
{{- mul (. | trimSuffix "Mi" | int64) 1000000 -}}
{{- else if . | hasSuffix "Gi" -}}
{{- mul (. | trimSuffix "Gi" | int64) 1000000000 -}}
{{- end }}
{{- end }}


{{- define "clickhouse.envVarName" -}}
{{- $user := .user | upper -}}
{{- $field := .field | upper -}}
{{- printf "CH_%s_%s" $user $field | replace "-" "_" -}}
{{- end -}}
