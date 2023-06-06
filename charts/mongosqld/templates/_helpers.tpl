{{/*
Expand the name of the chart.
*/}}
{{- define "mongosqld.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mongosqld.fullname" -}}
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
{{- define "mongosqld.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mongosqld.labels" -}}
helm.sh/chart: {{ include "mongosqld.chart" . }}
{{ include "mongosqld.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mongosqld.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mongosqld.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mongosqld.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mongosqld.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Common config
*/}}
{{- define "mongosqld.commonConfig" -}}
net:
  bindIp: 0.0.0.0
  port: 3306
  unixDomainSocket:
    enabled: false
{{- if or .Values.tlsCerts.create }}
  ssl:
    mode: requireSSL
    CAFile: /etc/ssl/tlscerts/tls.crt
    PEMKeyFile: /run/server.pem
    minimumTLSVersion: TLS1_2
{{- end }}

{{- if  .Values.config }}
{{ .Values.config }}
{{- else }}

mongodb:
  net:
    uri: "mongodb://{{ .Values.auth.host }}"
    auth:
      username: {{ .Values.auth.username }}
      password: {{ .Values.auth.password }}
      source: {{ .Values.auth.database }}

security:
  enabled: true
  defaultSource: {{ .Values.auth.database }}
{{- end }}

schema:
  maxVarcharLength: 8000
{{- if .Values.schema }}
  path: /etc/mongosqld/schema.drdl
{{- else }}
  refreshIntervalSecs: 3600
  {{- if ne .Values.schemaMode "memory" }}
  stored:
    name: {{ .Values.auth.database }}
    mode: {{ .Values.schemaMode }}
    source: "{{ .Values.auth.database }}Schema"
  {{- end }}

{{- end }}
{{- end }}

{{/*
MongoSQL drdl schema upload
*/}}
{{- define "mongosqld.schemaUpload" -}}
{{- $connSrc := printf "mongodb://%s:%s@%s/%s?authSource=%s" .Values.auth.username .Values.auth.password .Values.auth.host .Values.auth.database .Values.auth.database -}}
{{- $connDst := printf "mongodb://%s:%s@%s/%sSchema?authSource=%sSchema" .Values.auth.username .Values.auth.password .Values.auth.host .Values.auth.database .Values.auth.database -}}
#!/bin/sh
mongodrdl --uri={{ $connSrc }} --out /tmp/schema.drdl
mongodrdl --uri={{ $connDst }} upload --schemaSource={{ .Values.auth.database }}Schema --drdl /tmp/schema.drdl
{{- end }}
