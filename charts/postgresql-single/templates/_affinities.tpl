{{/*
Labels to use on common.affinities.pods
*/}}
{{- define "common.labels.matchLabels" -}}
{{- include "postgresql-single.selectorLabels" . }}
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
          {{ printf "app.kubernetes.io/component: %s" $component }}
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
          {{ printf "app.kubernetes.io/component: %s" $component }}
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
