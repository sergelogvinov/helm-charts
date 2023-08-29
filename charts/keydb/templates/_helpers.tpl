{{/*
Expand the name of the chart.
*/}}
{{- define "keydb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "keydb.fullname" -}}
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
{{- define "keydb.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "keydb.labels" -}}
helm.sh/chart: {{ include "keydb.chart" . }}
{{ include "keydb.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.podLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{- define "keydb.loadbalancer.labels" -}}
helm.sh/chart: {{ include "keydb.chart" . }}
{{ include "keydb.loadbalancer.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.podLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{- define "keydb.crontab.labels" -}}
helm.sh/chart: {{ include "keydb.chart" . }}
{{ include "keydb.crontab.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.podLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "keydb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "keydb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "keydb.loadbalancer.selectorLabels" -}}
app.kubernetes.io/name: {{ include "keydb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}-loadbalancer
{{- end }}

{{- define "keydb.crontab.selectorLabels" -}}
app.kubernetes.io/name: {{ include "keydb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}-crontab
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "keydb.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "keydb.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Common port
*/}}
{{- define "keydb.port" -}}
{{- if .Values.tlsCerts.create }}
{{- "6380" }}
{{- else }}
{{- "6379" }}
{{- end }}
{{- end }}


{{/*
Common config
*/}}
{{- define "keydb.commonConfig" -}}
bind 0.0.0.0 -::
port 6379

{{- if .Values.tlsCerts.create }}
tls-port 6380
tls-replication yes
tls-cluster yes
tls-allowlist {{ include "keydb.fullname" . }}.{{ .Release.Namespace }}.svc {{ include "keydb.fullname" . }}-client
tls-cert-file /etc/ssl/tlscerts/tls.crt
tls-key-file /etc/ssl/tlscerts/tls.key
tls-ca-cert-file /etc/ssl/tlscerts/ca.crt
tls-protocols "TLSv1.2 TLSv1.3"
tls-ciphers "DEFAULT:!MEDIUM"
tls-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
tls-prefer-server-ciphers yes

cluster-announce-tls-port 6380
{{- end }}
cluster-announce-port 6379

tcp-backlog 511
tcp-keepalive 300

maxclients 8192

server-threads {{ .Values.keydb.threads | int }}
active-replica {{ .Values.keydb.activeReplica }}
multi-master {{ .Values.keydb.multiMaster }}

loglevel notice
logfile ""

{{- if .Values.keydb.password }}
masterauth "{{ .Values.keydb.password  }}"
requirepass "{{ .Values.keydb.password  }}"
{{- end }}

{{- with .Values.keydb.save }}
save {{ . }}
{{- end }}

dir /data
dbfilename keydb.rdb

stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes

maxmemory-policy noeviction
{{- end }}


{{/*
Haproxy config
*/}}
{{- define "keydb.loadbalancerConfig" -}}
{{- $name := include "keydb.fullname" . }}
{{- $domain := printf "%s.svc.%s" .Release.Namespace .Values.clusterDomain }}
{{- $port := include "keydb.port" . }}
global
  maxconn 8192
  ssl-default-server-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
  ssl-default-server-options no-sslv3 no-tlsv10 no-tlsv11 no-tlsv12 no-tls-tickets
  ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
  ssl-default-bind-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384
  ssl-default-bind-options prefer-client-ciphers no-sslv3 no-tlsv10 no-tlsv11 no-tls-tickets
  stats socket /var/run/haproxy.sock mode 600 level admin
  server-state-file haproxy_state
  server-state-base /run

resolvers clusterdns
  parse-resolv-conf
  resolve_retries  3
  timeout resolve 1s
  timeout retry   1s
  hold other     60s
  hold refused   30s
  hold nx        30s
  hold timeout   30s
  hold valid     60s
  hold obsolete  60s

defaults
  mode tcp
  timeout connect  4s
  timeout server  30s
  timeout client  30s
  default-server  init-addr libc,none

frontend stats
  mode http
  bind *:8404
  http-request use-service prometheus-exporter if { path /metrics }
  stats enable
  stats uri /
  stats refresh 10s
  monitor-uri /healthz
  option dontlognull
  option clitcpka
  maxconn 16

frontend keydb_master
  bind *:6379
{{- if .Values.tlsCerts.create }}
  bind *:6380 ssl crt /run/server.pem ca-file /etc/ssl/tlscerts/ca.crt
{{- end }}
  option clitcpka
  use_backend keydb_master

backend keydb_master
  mode tcp
  balance  first
  fullconn 4096

  option tcp-check
{{- if .Values.tlsCerts.create }}
  tcp-check connect ssl
{{- else }}
  tcp-check connect
{{- end }}
{{- if .Values.keydb.password }}
  tcp-check send AUTH\ {{ .Values.keydb.password  }}\r\n
  tcp-check expect string +OK
{{- end }}
  tcp-check send PING\r\n
  tcp-check expect string +PONG
  tcp-check send info\ replication\r\n
{{- if eq .Values.keydb.activeReplica "yes" }}
  tcp-check expect string role:active-replica
{{- else }}
  tcp-check expect string role:master
{{- end }}
  tcp-check send QUIT\r\n
  tcp-check expect string +OK

{{- if .Values.tlsCerts.create }}
  default-server check check-ssl inter 15s fall 1 rise 1 on-marked-down shutdown-sessions resolve-prefer ipv4 ssl crt /run/server.pem ca-file /etc/ssl/tlscerts/ca.crt
{{- else }}
  default-server check inter 15s fall 1 rise 1 on-marked-down shutdown-sessions resolve-prefer ipv4
{{- end }}

  server RS {{ printf "%s.%s:%s" $name $domain $port }} backup no-check resolvers clusterdns
  server-template R {{if le (int .Values.replicaCount) 3}}3{{else}}{{ .Values.replicaCount }}{{end}} {{ printf "%s-headless.%s:%s" $name $domain $port }} resolvers clusterdns
{{ end }}


{{/*
Backup wal-g config
*/}}
{{- define "keydb.walgYaml" -}}
WALG_COMPRESSION_METHOD: brotli
WALG_DELTA_MAX_STEPS: 4
WALG_STREAM_CREATE_COMMAND: "redis-cli -h {{ include "keydb.fullname" . }}-0.{{ include "keydb.fullname" . }}-headless.{{ .Release.Namespace }}.svc --rdb -"
WALG_STREAM_RESTORE_COMMAND: "cat > /data/dump.rdb"
{{- if .Values.keydb.password }}
WALG_REDIS_PASSWORD: "{{ .Values.keydb.password  }}"
{{- end }}
{{- if not .Values.backup.walg }}
WALG_FILE_PREFIX: /data
{{- else }}
{{ .Values.backup.walg | toYaml }}
{{- end }}
{{- end }}


{{/*
Return a soft podAffinity/podAntiAffinity definition
*/}}
{{- define "affinities.pods.soft" -}}
preferredDuringSchedulingIgnoredDuringExecution:
  - podAffinityTerm:
      labelSelector:
        matchLabels: {{- (include "keydb.selectorLabels" .) | nindent 10 }}
      namespaces:
        - {{ .Release.Namespace | quote }}
      topologyKey: {{ .Values.podAntiAffinityPresetKey }}
    weight: 1
{{- end -}}


{{/*
Return a hard podAffinity/podAntiAffinity definition
*/}}
{{- define "affinities.pods.hard" -}}
requiredDuringSchedulingIgnoredDuringExecution:
  - labelSelector:
      matchLabels: {{- (include "keydb.selectorLabels" .) | nindent 8 }}
    namespaces:
      - {{ .Release.Namespace | quote }}
    topologyKey: {{ .Values.podAntiAffinityPresetKey }}
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
*/}}
{{- define "affinities.loadbalancer.pods.soft" -}}
podAntiAffinity:
  preferredDuringSchedulingIgnoredDuringExecution:
    - podAffinityTerm:
        labelSelector:
          matchLabels: {{- (include "keydb.loadbalancer.selectorLabels" .) | nindent 12 }}
        namespaces:
          - {{ .Release.Namespace | quote }}
        topologyKey: kubernetes.io/hostname
      weight: 1
podAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
    - labelSelector:
        matchLabels: {{- (include "keydb.selectorLabels" .) | nindent 10 }}
      namespaces:
        - {{ .Release.Namespace | quote }}
      topologyKey: kubernetes.io/hostname
{{- end -}}


{{/*
Return a hard podAffinity/podAntiAffinity definition
*/}}
{{- define "affinities.loadbalancer.pods.hard" -}}
podAntiAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
    - labelSelector:
        matchLabels: {{- (include "keydb.loadbalancer.selectorLabels" .) | nindent 10 }}
      namespaces:
        - {{ .Release.Namespace | quote }}
      topologyKey: kubernetes.io/hostname
podAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
    - labelSelector:
        matchLabels: {{- (include "keydb.selectorLabels" .) | nindent 10 }}
      namespaces:
        - {{ .Release.Namespace | quote }}
      topologyKey: kubernetes.io/hostname
{{- end -}}


{{/*
Return a podAffinity/podAntiAffinity definition
*/}}
{{- define "affinities.loadbalancer.pods" -}}
  {{- if eq .Values.loadbalancer.podAntiAffinityPreset "soft" }}
    {{- include "affinities.loadbalancer.pods.soft" . -}}
  {{- else if eq .Values.loadbalancer.podAntiAffinityPreset "hard" }}
    {{- include "affinities.loadbalancer.pods.hard" . -}}
  {{- end -}}
{{- end -}}
