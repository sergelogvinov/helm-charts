{{/*
Expand the name of the chart.
*/}}
{{- define "github-actions-runner.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "github-actions-runner.fullname" -}}
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
{{- define "github-actions-runner.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "github-actions-runner.labels" -}}
helm.sh/chart: {{ include "github-actions-runner.chart" . }}
{{ include "github-actions-runner.selectorLabels" . }}
app.kubernetes.io/version: "0.5.0"
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "github-actions-runner.selectorLabels" -}}
app.kubernetes.io/name: {{ include "github-actions-runner.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "github-actions-runner.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "github-actions-runner.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "github-actions-runner.managerRoleName" -}}
{{- include "github-actions-runner.fullname" . }}-manager
{{- end }}

{{- define "github-actions-runner.managerServiceAccountName" -}}
{{- .Values.controllerServiceAccount.name }}
{{- end }}

{{/*
Return a soft podAffinity/podAntiAffinity definition
*/}}
{{- define "affinities.pods.soft" -}}
preferredDuringSchedulingIgnoredDuringExecution:
  - podAffinityTerm:
      labelSelector:
        matchLabels: {{- (include "github-actions.selectorLabels" .) | nindent 10 }}
      namespaces:
        - {{ .Release.Namespace | quote }}
      topologyKey: kubernetes.io/hostname
    weight: 1
{{- end -}}

{{/*
Return a hard podAffinity/podAntiAffinity definition
*/}}
{{- define "affinities.pods.hard" -}}
requiredDuringSchedulingIgnoredDuringExecution:
  - labelSelector:
      matchLabels: {{- (include "github-actions.selectorLabels" .) | nindent 8 }}
    namespaces:
      - {{ .Release.Namespace | quote }}
    topologyKey: kubernetes.io/hostname
{{- end -}}

{{/*
Return a podAffinity/podAntiAffinity definition
*/}}
{{- define "affinities.pods" -}}
  {{- if eq .Values.podAntiAffinityPreset "soft" }}
    {{- include "affinities.pods.soft" . -}}
  {{- else if eq .Values.podAntiAffinityPreset "hard" }}
    {{- include "affinities.pods.hard" . -}}
  {{- end -}}
{{- end -}}

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
