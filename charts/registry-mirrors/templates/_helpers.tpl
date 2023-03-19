{{/*
Expand the name of the chart.
*/}}
{{- define "registry-mirrors.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "registry-mirrors.fullname" -}}
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
{{- define "registry-mirrors.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "registry-mirrors.labels" -}}
helm.sh/chart: {{ include "registry-mirrors.chart" . }}
{{ include "registry-mirrors.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "registry-mirrors.selectorLabels" -}}
app.kubernetes.io/name: {{ include "registry-mirrors.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "registry-mirrors.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "registry-mirrors.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the mirror auth password
*/}}
{{- define "registry-mirrors.password" -}}
{{- $sname := include "registry-mirrors.fullname" . }}
{{- $previous := lookup "v1" "Secret" .Release.Namespace $sname }}
{{- if .Values.auth.password }}
{{- .Values.password }}
{{- else if and $previous $previous.data.password }}
{{- default (randAlphaNum 16) ($previous.data.password | b64dec ) }}
{{- else }}
{{- randAlphaNum 16 }}
{{- end }}
{{- end }}
