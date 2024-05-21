{{/*
Expand the name of the chart.
*/}}
{{- define "backend-common.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "backend-common.fullname" -}}
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
{{- define "backend-common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "backend-common.labels" -}}
{{- if .Values.podLabels }}
{{- toYaml .Values.podLabels }}
{{- end }}
helm.sh/chart: {{ include "backend-common.chart" . }}
{{ include "backend-common.selectorLabels" . }}
app.kubernetes.io/version: {{ default .Chart.AppVersion .Values.image.tag | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "backend-common.selectorLabels" -}}
app.kubernetes.io/name: {{ include "backend-common.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "backend-common.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "backend-common.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified deployment name.
{{ include "backend-common.deployment" (dict "name" $key "context" $) }}
*/}}
{{- define "backend-common.deployment" -}}
{{- if eq .name .context.Release.Name }}
{{- .context.Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else }}
{{- printf "%s-%s" .context.Release.Name .name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "backend-common.configConfigMap" -}}
{{- if .Values.configConfigMap }}
{{- .Values.configConfigMap }}
{{- else }}
{{- include "backend-common.fullname" . -}}
{{- end }}
{{- end }}
