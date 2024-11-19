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

{{- define "github-actions-runner.registry.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}-registry
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}-registry
{{- else }}
{{- printf "%s-%s-registry" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "github-actions-runner.mirrors.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}-mirrors
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}-mirrors
{{- else }}
{{- printf "%s-%s-mirrors" .Release.Name $name | trunc 63 | trimSuffix "-" }}
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
app.kubernetes.io/version: "{{ .Values.runnerVersion }}"
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
Labels to use on common.affinities.pods
*/}}
{{- define "common.labels.matchLabels" -}}
app.kubernetes.io/name: {{ include "github-actions-runner.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

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

{{/*
Create the name of the service account to use by mirrors
*/}}
{{- define "github-actions-runner.mirrors.serviceAccountName" -}}
{{- if .Values.mirrors.serviceAccount.create }}
{{- default (include "github-actions-runner.mirrors.fullname" .) .Values.mirrors.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.mirrors.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "github-actions-runner.registry.serviceAccountName" -}}
{{- if .Values.registry.serviceAccount.create }}
{{- default (include "github-actions-runner.registry.fullname" .) .Values.registry.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.registry.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Define managerRoleName
*/}}
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
        matchLabels:
          {{- (include "github-actions-runner.selectorLabels" .) | nindent 10 }}
          app.kubernetes.io/component: autoscaling-runner-set
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
      matchLabels:
        {{- (include "github-actions-runner.selectorLabels" .) | nindent 8 }}
        app.kubernetes.io/component: autoscaling-runner-set
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
Return a soft podAffinity/podAntiAffinity definition
{{ include "common.affinities.pods.soft" (dict "component" "FOO" "topologyKey" .Values.topologyKey "labels" .Values.labels "context" $) -}}
*/}}
{{- define "common.affinities.pods.soft" -}}
{{- $component := default "" .component -}}
{{- $labels := default (dict) .labels -}}
{{- if $labels -}}
preferredDuringSchedulingIgnoredDuringExecution:
  - podAffinityTerm:
      labelSelector:
        matchLabels:
          {{- if not (empty $component) }}
          {{ printf "app.kubernetes.io/component: \"%s\"" $component }}
          {{- end }}
          {{- range $key, $value := $labels }}
          {{ $key }}: {{ $value | quote }}
          {{- end }}
      topologyKey: {{ .topologyKey | default "kubernetes.io/hostname" }}
    weight: 1
{{- else -}}
preferredDuringSchedulingIgnoredDuringExecution:
  - podAffinityTerm:
      labelSelector:
        matchLabels: {{- (include "common.labels.matchLabels" .context) | nindent 10 }}
          {{- if not (empty $component) }}
          {{ printf "app.kubernetes.io/component: \"%s\"" $component }}
          {{- end }}
          {{- range $key, $value := $labels }}
          {{ $key }}: {{ $value | quote }}
          {{- end }}
      topologyKey: {{ .topologyKey | default "kubernetes.io/hostname" }}
    weight: 1
{{- end -}}
{{- end -}}

{{/*
Return a hard podAffinity/podAntiAffinity definition
{{ include "common.affinities.pods.hard" (dict "component" "FOO" "topologyKey" .Values.topologyKey "labels" .Values.labels "context" $) -}}
*/}}
{{- define "common.affinities.pods.hard" -}}
{{- $component := default "" .component -}}
{{- $labels := default (dict) .labels -}}
{{- if $labels -}}
requiredDuringSchedulingIgnoredDuringExecution:
  - labelSelector:
      matchLabels:
        {{- if not (empty $component) }}
        {{ printf "app.kubernetes.io/component: \"%s\"" $component }}
        {{- end }}
        {{- range $key, $value := $labels }}
        {{ $key }}: {{ $value | quote }}
        {{- end }}
    topologyKey: {{ .topologyKey | default "kubernetes.io/hostname" }}
{{- else -}}
requiredDuringSchedulingIgnoredDuringExecution:
  - labelSelector:
      matchLabels: {{- (include "common.labels.matchLabels" .context) | nindent 8 }}
        {{- if not (empty $component) }}
        {{ printf "app.kubernetes.io/component: \"%s\"" $component }}
        {{- end }}
        {{- range $key, $value := $labels }}
        {{ $key }}: {{ $value | quote }}
        {{- end }}
    topologyKey: {{ .topologyKey | default "kubernetes.io/hostname" }}
{{- end -}}
{{- end -}}

{{/*
Return a podAffinity/podAntiAffinity definition
{{ include "common.affinities.pods" (dict "type" "soft" "key" "FOO" "values" (list "BAR" "BAZ")) -}}
*/}}
{{- define "common.affinities.pods" -}}
  {{- if eq .type "soft" }}
    {{- include "common.affinities.pods.soft" . -}}
  {{- else if eq .type "hard" }}
    {{- include "common.affinities.pods.hard" . -}}
  {{- end -}}
{{- end -}}

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

{{- define "github-actions-runner.credentialsFile" -}}
{{- range $inx, $val := .Values.mirrors.registry }}{{- if and $val.auth $val.auth.username }}
{{- $val.host }}: {{- toYaml $val.auth | nindent 2 }}
{{- if eq $val.host "docker.io" }}
index.docker.io: {{- toYaml $val.auth | nindent 2 }}
registry-1.docker.io: {{- toYaml $val.auth | nindent 2 }}
{{- end }}
{{ end }}{{- end }}
{{- end }}
