# victoria-metrics-storage

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

Predefined resources for Victoria Metrics Operator

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/main/charts/victoria-metrics-storage>
* <https://github.com/VictoriaMetrics>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| vmStorage.replicaCount | int | `1` |  |
| vmStorage.autoscaling.enabled | bool | `false` |  |
| vmStorage.extraArgs.enableTCP6 | string | `"true"` |  |
| vmStorage.resources | object | `{"limits":{"cpu":2,"memory":"4Gi"},"requests":{"cpu":1,"memory":"1Gi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| vmStorage.persistence.enabled | bool | `false` |  |
| vmStorage.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| vmStorage.persistence.size | string | `"10Gi"` |  |
| vmStorage.persistence.annotations | object | `{}` |  |
| vmStorage.nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| vmStorage.tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| vmStorage.affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| vmSelect.replicaCount | int | `1` |  |
| vmSelect.autoscaling.enabled | bool | `false` |  |
| vmSelect.extraArgs.enableTCP6 | string | `"true"` |  |
| vmSelect.resources | object | `{"limits":{"cpu":1,"memory":"1Gi"},"requests":{"cpu":"500m","memory":"512Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| vmSelect.persistence.enabled | bool | `false` |  |
| vmSelect.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| vmSelect.persistence.size | string | `"10Gi"` |  |
| vmSelect.persistence.annotations | object | `{}` |  |
| vmSelect.nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| vmSelect.tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| vmSelect.affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| vmInsert.replicaCount | int | `1` |  |
| vmInsert.autoscaling.enabled | bool | `false` |  |
| vmInsert.extraArgs.enableTCP6 | string | `"true"` |  |
| vmInsert.resources | object | `{"limits":{"cpu":1,"memory":"1Gi"},"requests":{"cpu":"500m","memory":"512Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| vmInsert.nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| vmInsert.tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| vmInsert.affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| vmAlert.replicaCount | int | `1` |  |
| vmAlert.autoscaling.enabled | bool | `false` |  |
| vmAlert.extraArgs.enableTCP6 | string | `"true"` |  |
| vmAlert.secrets | list | `[]` |  |
| vmAlert.configMaps | list | `[]` |  |
| vmAlert.rulePath | list | `[]` |  |
| vmAlert.resources | object | `{"limits":{"cpu":1,"memory":"1Gi"},"requests":{"cpu":"500m","memory":"512Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| vmAlert.nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| vmAlert.tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| vmAlert.affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| ingress.enabled | bool | `false` |  |
| ingress.className | string | `""` |  |
| ingress.annotations | object | `{}` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| priorityClassName | string | `nil` | Priority Class Name ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass |
| podlabels | object | `{}` | Extra labels for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
