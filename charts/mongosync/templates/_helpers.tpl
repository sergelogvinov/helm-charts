{{/*
Expand the name of the chart.
*/}}
{{- define "mongosync.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mongosync.fullname" -}}
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
{{- define "mongosync.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mongosync.labels" -}}
helm.sh/chart: {{ include "mongosync.chart" . }}
{{ include "mongosync.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mongosync.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mongosync.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mongosync.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mongosync.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
MongoSync filters
*/}}
{{- define "mongosync.filters" -}}
source: cluster0
destination: cluster1
{{- if ne (len .Values.filters) 0 }}
includeNamespaces: {{ toYaml .Values.filters | nindent 2 }}
{{- end }}
{{- end }}


{{/*
MongoSync start script
*/}}
{{- define "mongosync.start" -}}
#!/bin/sh

is_down=true
while "$is_down"; do
if curl --fail --silent --connect-timeout 5 http://127.0.0.1:{{ .Values.service.port }}/api/v1/progress;
then
    is_down=false
else
    sleep 10
fi
done

curl -XPOST http://127.0.0.1:{{ .Values.service.port }}/api/v1/start --data @/etc/mongosync/filters.json
{{- end }}


{{/*
MongoSync stop/finish script
*/}}
{{- define "mongosync.finish" -}}
#!/bin/sh
#
# https://www.mongodb.com/docs/cluster-to-cluster-sync/current/reference/api/commit/
#

curl --fail --silent --connect-timeout 5 http://127.0.0.1:{{ .Values.service.port }}/api/v1/progress | jq '.progress.canCommit'

curl -XPOST http://127.0.0.1:{{ .Values.service.port }}/api/v1/commit --data '{}'
{{- end }}
