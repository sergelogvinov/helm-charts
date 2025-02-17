# victoria-metrics

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

Predefined resources for Victoria Metrics Operator

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/main/charts/victoria-metrics>
* <https://github.com/VictoriaMetrics>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| vmAgent.extraArgs."promscrape.maxScrapeSize" | string | `"67108864"` |  |
| vmAgent.extraArgs."promscrape.maxDroppedTargets" | string | `"10000"` |  |
| vmAgent.extraArgs."promscrape.streamParse" | string | `"true"` |  |
| vmAgent.extraArgs."promscrape.suppressDuplicateScrapeTargetErrors" | string | `"true"` |  |
| vmAgent.secrets | list | `[]` |  |
| vmAgent.configMaps | list | `[]` |  |
| vmAgent.externalLabels | object | `{}` |  |
| vmAgent.additionalScrapeConfigs.name | string | `"prometheus-rules-scrape"` |  |
| vmAgent.additionalScrapeConfigs.key | string | `"scrape.yml"` |  |
| vmAgent.remoteWrite | list | `[]` |  |
| vmAgent.resources | object | `{"limits":{"cpu":1,"memory":"2Gi"},"requests":{"cpu":"100m","memory":"256Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| vmAlert.secrets | list | `[]` |  |
| vmAlert.configMaps[0] | string | `"prometheus-rules-config"` |  |
| vmAlert.configMaps[1] | string | `"prometheus-rules"` |  |
| vmAlert.rulePath[0] | string | `"/etc/vm/configs/prometheus-rules-config/recording_rules.yml"` |  |
| vmAlert.rulePath[1] | string | `"/etc/vm/configs/prometheus-rules/*.yml"` |  |
| vmAlert.resources | object | `{"limits":{"cpu":"200m","memory":"256Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| vmSingle.extraArgs.maxLabelsPerTimeseries | string | `"40"` |  |
| vmSingle.resources | object | `{"limits":{"cpu":2,"memory":"3Gi"},"requests":{"cpu":"500m","memory":"2Gi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| priorityClassName | string | `nil` | Priority Class Name ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
