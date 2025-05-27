{{- /*
Generated file. Do not change in-place! In order to change this file first read following link:
https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack/hack
*/ -}}
{{- define "rules" }}
{{- include "alertmanager.rules" . }}
{{- include "config-reloaders" . }}
{{- include "general.rules" . }}
{{- include "k8s.rules.container_cpu_limits" . }}
{{- include "k8s.rules.container_cpu_requests" . }}
{{- include "k8s.rules.container_cpu_usage_seconds_total" . }}
{{- include "k8s.rules.container_memory_cache" . }}
{{- include "k8s.rules.container_memory_limits" . }}
{{- include "k8s.rules.container_memory_requests" . }}
{{- include "k8s.rules.container_memory_rss" . }}
{{- include "k8s.rules.container_memory_swap" . }}
{{- include "k8s.rules.container_memory_working_set_bytes" . }}
{{- include "k8s.rules.container_resource" . }}
{{- include "k8s.rules.pod_owner" . }}
{{- include "kube-apiserver-availability.rules" . }}
{{- include "kube-apiserver-burnrate.rules" . }}
{{- include "kube-apiserver-histogram.rules" . }}
{{- include "kube-apiserver-slos" . }}
{{- include "kube-prometheus-general.rules" . }}
{{- include "kube-prometheus-node-recording.rules" . }}
{{- include "kube-scheduler.rules" . }}
{{- include "kube-state-metrics" . }}
{{- include "kubelet.rules" . }}
{{- include "kubernetes-apps" . }}
{{- include "kubernetes-resources" . }}
{{- include "kubernetes-storage" . }}
{{- include "kubernetes-system" . }}
{{- include "kubernetes-system-apiserver" . }}
{{- include "kubernetes-system-kubelet" . }}
{{- include "kubernetes-system-controller-manager" . }}
{{- include "kubernetes-system-scheduler" . }}
{{- include "node-exporter.rules" . }}
{{- include "node-exporter" . }}
{{- include "node.rules" . }}
{{- include "node-network" . }}
{{- include "prometheus-operator" . }}
{{- include "prometheus" . }}
{{- end }}