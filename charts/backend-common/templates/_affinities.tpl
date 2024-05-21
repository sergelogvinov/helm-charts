{{/* vim: set filetype=mustache: */}}

{{/*
Labels to use on common.affinities.pods
*/}}
{{- define "common.labels.matchLabels" -}}
app.kubernetes.io/name: {{ include "backend-common.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ default .Chart.AppVersion .Values.image.tag | quote }}
{{- end -}}

{{/*
Return a soft nodeAffinity definition
{{ include "common.affinities.nodes.soft" (dict "key" "FOO" "expressions" (list (dict key "A" values (list "BAR" "BAZ")))) -}}
*/}}
{{- define "common.affinities.nodes.soft" -}}
preferredDuringSchedulingIgnoredDuringExecution:
  - preference:
      matchExpressions:
        {{- $keys := list "" }}
        {{- range .expressions }}
        {{- if not (has .key $keys) }}{{ $keys = append $keys .key }}
        - key: {{ .key }}
          operator: {{ default "In" .operator }}
          values:
            {{- range .values }}
            - {{ . | quote }}
            {{- end }}
        {{- end }}
        {{- else }}
        - key: {{ .key }}
          operator: {{ default "In" .operator }}
          values:
            {{- range .values }}
            - {{ . | quote }}
            {{- end }}
        {{- end }}
    weight: 1
{{- end -}}

{{/*
Return a hard nodeAffinity definition
{{ include "common.affinities.nodes.hard" (dict "type" "soft" "expressions" (list (dict key "A" values (list "BAR" "BAZ"))))-}}
*/}}
{{- define "common.affinities.nodes.hard" -}}
requiredDuringSchedulingIgnoredDuringExecution:
  nodeSelectorTerms:
    - matchExpressions:
        {{- $keys := list "" }}
        {{- range .expressions }}
        {{- if not (has .key $keys) }}{{ $keys = append $keys .key }}
        - key: {{ .key }}
          operator: {{ default "In" .operator }}
          values:
            {{- range .values }}
            - {{ . | quote }}
            {{- end }}
        {{- end }}
        {{- else }}
        - key: {{ .key }}
          operator: {{ default "In" .operator }}
          values:
            {{- range .values }}
            - {{ . | quote }}
            {{- end }}
        {{- end }}
{{- end -}}

{{/*
Return a nodeAffinity definition
{{ include "common.affinities.nodes" (dict "type" "soft" "expressions" (list (dict key "A" values (list "BAR" "BAZ")))) -}}
*/}}
{{- define "common.affinities.nodes" -}}
  {{- if eq .type "soft" }}
    {{- include "common.affinities.nodes.soft" . -}}
  {{- else if eq .type "hard" }}
    {{- include "common.affinities.nodes.hard" . -}}
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
