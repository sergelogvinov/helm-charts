{{/*
Name of kube-ingress-aws-controller
*/}}
{{- define "kiac.name" -}}
{{- default "kube-ingress-aws-controller" .Values.kiac.nameOverride
    | trunc 63 | trimSuffix "-"  }}
{{- end }}

{{/*
Full Name of kube-ingress-aws-controller
*/}}
{{- define "kiac.fullname" -}}
{{- if .Values.kiac.fullnameOverride }}
{{- .Values.kiac.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- include "kiac.name" . }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kiac.labels" -}}
helm.sh/chart: {{ include "skipper.chart" . }}
{{ include "kiac.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.kiac.podLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kiac.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kiac.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the KIAC service account to use
*/}}
{{- define "kiac.serviceAccountName" -}}
{{- if .Values.kiac.serviceAccount.create }}
{{- default (include "kiac.fullname" .) .Values.kiac.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.kiac.serviceAccount.name }}
{{- end }}
{{- end }}
