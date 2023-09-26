{{/*
Expand the name of the chart.
*/}}
{{- define "link-common.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "link-common.fullname" -}}
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
{{- define "link-common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "link-common.labels" -}}
helm.sh/chart: {{ include "link-common.chart" . }}
{{ include "link-common.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "link-common.selectorLabels" -}}
app.kubernetes.io/name: {{ include "link-common.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "link-common.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "link-common.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "link-common-wireguard.conf" -}}
[Interface]
Address = {{ .Values.wireguard.wireguardIP }}
PrivateKey = {{ .Values.wireguard.wireguardKey }}
ListenPort = 51820
MTU = {{ .Values.wireguard.wireguardMTU }}

{{ range $key,$values := .Values.wireguard.peers }}
[Peer]
# friendly_name = {{ $key }}
{{- range $peer,$peer_value := $values }}
{{ $peer | title }} = {{ $peer_value }}
{{- end }}
{{ end }}
{{- end }}
