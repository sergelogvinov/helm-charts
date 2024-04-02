{{/*
Expand the name of the chart.
*/}}
{{- define "ipsec.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ipsec.fullname" -}}
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
{{- define "ipsec.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ipsec.labels" -}}
helm.sh/chart: {{ include "ipsec.chart" . }}
{{ include "ipsec.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ipsec.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ipsec.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ipsec.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ipsec.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "ipsec.secrets" -}}
{{ .Values.secrets }}
{{- end }}

{{- define "ipsec.passwd" -}}
{{- range $key, $value := .Values.users }}
{{ $key }}:{{ $value }}:xauth-psk
{{- end }}
{{- end }}

{{- define "ipsec.conf" -}}
version 2
config setup
    protostack=netkey
    virtual-private={{ .Values.ipsecService.networks }}
    uniqueids=no
    # plutodebug=base

conn service
    left=%defaultroute
    leftsubnet={{ .Values.ipsecService.ip }}/32

    right=%any
    rightaddresspool=172.30.240.1-172.30.240.254

    # MacOS hack?
    modecfgdns={{ .Values.ipsecService.ip }}
    modecfgdomains={{ .Release.Namespace }}.svc.cluster.local
    modecfgpull=yes

{{ .Values.config }}
{{- end }}
