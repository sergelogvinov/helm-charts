# teamcity

![Version: 0.6.16](https://img.shields.io/badge/Version-0.6.16-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2024.07.3](https://img.shields.io/badge/AppVersion-2024.07.3-informational?style=flat-square)

Teamcity on Kubernetes

TeamCity is a build management and CI/CD server from JetBrains.
Self-hosted version of TeamCity is available for free for small teams.
You can run TeamCity on Kubernetes using this Helm chart.

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/master/charts/teamcity>
* <https://www.jetbrains.com/teamcity>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| server.enabled | bool | `true` |  |
| server.image.repository | string | `"ghcr.io/sergelogvinov/teamcity"` |  |
| server.image.pullPolicy | string | `"IfNotPresent"` |  |
| server.image.tag | string | `""` |  |
| server.configDb | list | `[]` |  |
| server.updateStrategy.type | string | `"Recreate"` |  |
| server.serviceAccount.create | bool | `true` |  |
| server.serviceAccount.annotations | object | `{}` |  |
| server.serviceAccount.name | string | `""` |  |
| server.podAnnotations | object | `{}` |  |
| server.podSecurityContext.fsGroup | int | `1000` |  |
| server.podSecurityContext.fsGroupChangePolicy | string | `"OnRootMismatch"` |  |
| server.securityContext.runAsUser | int | `1000` |  |
| server.securityContext.runAsGroup | int | `1000` |  |
| server.resources.requests.cpu | string | `"500m"` |  |
| server.resources.requests.memory | string | `"1Gi"` |  |
| server.priorityClassName | string | `nil` | Priority Class Name ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass |
| server.persistentVolume.enabled | bool | `true` |  |
| server.persistentVolume.annotations | object | `{}` |  |
| server.persistentVolume.accessModes[0] | string | `"ReadWriteOnce"` |  |
| server.persistentVolume.size | string | `"10Gi"` |  |
| server.persistentVolume.storageClass | string | `""` |  |
| server.persistentVolume.existingClaim | string | `""` |  |
| server.nodeSelector | object | `{}` |  |
| server.tolerations | list | `[]` |  |
| server.affinity | object | `{}` |  |
| agent.enabled | bool | `true` |  |
| agent.image.repository | string | `"ghcr.io/sergelogvinov/teamcity"` |  |
| agent.image.pullPolicy | string | `"IfNotPresent"` |  |
| agent.image.tag | string | `""` |  |
| agent.replicaCount | int | `0` |  |
| agent.envs | object | `{}` |  |
| agent.updateStrategy.type | string | `"Recreate"` |  |
| agent.serviceAccount.create | bool | `true` |  |
| agent.serviceAccount.annotations | object | `{}` |  |
| agent.serviceAccount.name | string | `""` |  |
| agent.rbac.create | bool | `false` |  |
| agent.rbac.rules | list | `[]` |  |
| agent.podAnnotations | object | `{}` |  |
| agent.podSecurityContext.fsGroup | int | `1000` |  |
| agent.podSecurityContext.fsGroupChangePolicy | string | `"OnRootMismatch"` |  |
| agent.securityContext.runAsNonRoot | bool | `true` |  |
| agent.securityContext.runAsUser | int | `1000` |  |
| agent.securityContext.runAsGroup | int | `1000` |  |
| agent.resources.requests.cpu | string | `"500m"` |  |
| agent.resources.requests.memory | string | `"512Mi"` |  |
| agent.priorityClassName | string | `nil` | Priority Class Name ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass |
| agent.extraVolumeMounts | list | `[]` |  |
| agent.extraVolumes | list | `[]` |  |
| agent.nodeSelector | object | `{}` |  |
| agent.tolerations | list | `[]` |  |
| agent.affinity | object | `{}` |  |
| dind.enabled | bool | `true` |  |
| dind.image | object | `{"pullPolicy":"IfNotPresent","repository":"docker","tag":"25.0-dind"}` | Docker in Docker image. ref: https://hub.docker.com/_/docker/tags?page=1&name=dind |
| dind.resources | object | `{"limits":{"cpu":1,"memory":"2Gi"},"requests":{"cpu":"500m","memory":"512Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| dind.extraVolumeMounts | list | `[]` | Additional container volume mounts. |
| dind.extraVolumes | list | `[]` | Additional volumes. |
| dind.persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"enabled":false,"size":"100Gi"}` | Persistence parameters for source code ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| service.type | string | `"ClusterIP"` |  |
| service.port | int | `80` |  |
| ingress.enabled | bool | `false` |  |
| ingress.className | string | `""` |  |
| ingress.annotations | object | `{}` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths | list | `[]` |  |
| ingress.tls | list | `[]` |  |
| metrics.enabled | bool | `false` |  |
| metrics.username | string | `"prometheus"` |  |
| metrics.password | string | `"prometheus"` |  |
| metrics.image.repository | string | `"nginx"` |  |
| metrics.image.pullPolicy | string | `"IfNotPresent"` |  |
| metrics.image.tag | string | `"1.23.0-alpine"` |  |
| metrics.securityContext.runAsNonRoot | bool | `true` |  |
| metrics.securityContext.runAsUser | int | `101` |  |
| metrics.securityContext.runAsGroup | int | `101` |  |
| postgresql.enabled | bool | `false` |  |
| postgresql.postgresqlDatabase | string | `"teamcity"` |  |
| postgresql.postgresqlUsername | string | `"teamcity"` |  |
| postgresql.postgresqlPassword | string | `"teamcity"` |  |
