# clickhouse-keeper

![Version: 0.1.3](https://img.shields.io/badge/Version-0.1.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 23.12.6-alpine](https://img.shields.io/badge/AppVersion-23.12.6--alpine-informational?style=flat-square)

A Helm chart for Kubernetes

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/master/charts/clickhouse>
* <https://github.com/ClickHouse/ClickHouse>
* <https://hub.docker.com/r/clickhouse/clickhouse-server>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` |  |
| image.repository | string | `"clickhouse/clickhouse-server"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.name | string | `""` |  |
| podlabels | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| priorityClassName | string | `nil` |  |
| terminationGracePeriodSeconds | string | `nil` |  |
| service.type | string | `"ClusterIP"` |  |
| service.port | int | `2181` |  |
| resources.requests.cpu | string | `"100m"` |  |
| resources.requests.memory | string | `"128Mi"` |  |
| persistence.enabled | bool | `false` |  |
| updateStrategy.type | string | `"RollingUpdate"` |  |
| metrics.enabled | bool | `false` |  |
| nodeSelector | object | `{}` |  |
| tolerations | list | `[]` |  |
| affinity | object | `{}` |  |

