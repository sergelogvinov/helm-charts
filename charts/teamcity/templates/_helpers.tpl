{{/*
Expand the name of the chart.
*/}}
{{- define "teamcity.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "teamcity.fullname" -}}
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
{{- define "teamcity.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "teamcity.labels" -}}
helm.sh/chart: {{ include "teamcity.chart" . }}
{{ include "teamcity.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "teamcity.selectorLabels" -}}
app.kubernetes.io/name: {{ include "teamcity.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "teamcity.server.serviceAccountName" -}}
{{- if .Values.server.serviceAccount.create }}
{{- default (include "teamcity.fullname" .) .Values.server.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.server.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "teamcity.agent.serviceAccountName" -}}
{{- if .Values.agent.serviceAccount.create }}
{{- default (printf "%s-agent" (include "teamcity.fullname" .)) .Values.agent.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.agent.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the database.properties file
*/}}
{{- define "teamcity.server.databaseProperties" -}}
{{- if .Values.postgresql.enabled }}
connectionProperties.user={{ .Values.postgresql.postgresqlUsername }}
connectionUrl=jdbc\:postgresql\://{{ include "teamcity.fullname" . }}-postgresql/{{ .Values.postgresql.postgresqlDatabase }}
connectionProperties.password={{ .Values.postgresql.postgresqlPassword }}
{{- else }}
{{ .Values.server.configDb | default "" }}
{{- end }}
{{- end }}

{{/*
Create the nginx.conf file
*/}}
{{- define "teamcity.metrics" -}}
error_log /dev/stderr error;
pid       /tmp/nginx.pid;

worker_processes    1;

events {
  worker_connections 128;
}

http {
    server_tokens           off;
    server_name_in_redirect off;
    gzip                    off;
    types_hash_max_size     2048;
    client_max_body_size    8m;

    default_type text/html;

    access_log  off;
    error_log   /dev/stderr;

    client_body_temp_path /tmp/client_temp;
    proxy_temp_path       /tmp/proxy_temp_path;
    fastcgi_temp_path     /tmp/fastcgi_temp;
    uwsgi_temp_path       /tmp/uwsgi_temp;
    scgi_temp_path        /tmp/scgi_temp;

{{- if .Values.metrics.enabled }}
    server {
        listen 9180;

        location / {
            return 404;
        }
        location /app/metrics {
            proxy_set_header Authorization "Basic {{ printf "%s:%s" .Values.metrics.username .Values.metrics.password | b64enc }}";
            proxy_pass http://127.0.0.1:8111;
        }
    }
{{- end }}
}
{{- end }}

{{/*
Convert a memory resource like "500Mi" to the number 500 (Megabytes)
*/}}
{{- define "resource-mb" -}}
{{- if . | hasSuffix "Mi" -}}
{{- (. | trimSuffix "Mi" | int64) -}}
{{- else if . | hasSuffix "Gi" -}}
{{- mul (. | trimSuffix "Gi" | int64) 1000 -}}
{{- end }}
{{- end }}

{{/*
Renders a volumeClaimTemplate.
Usage:
{{ include "volumeClaimTemplate.render" .Values.persistence }}
*/}}
{{- define "volumeClaimTemplate.spec.render" -}}
spec:
  accessModes:
  {{- range .accessModes }}
    - {{ . | quote }}
  {{- end }}
  resources:
    requests:
      storage: {{ .size | quote }}
{{- if .storageClass }}
{{- if (eq "-" .storageClass) }}
  storageClassName: ""
{{- else }}
  storageClassName: "{{ .storageClass }}"
{{- end }}
{{- end }}
{{- end }}
