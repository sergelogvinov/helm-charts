# clickhouse-keeper

![Version: 0.1.4](https://img.shields.io/badge/Version-0.1.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 24.8](https://img.shields.io/badge/AppVersion-24.8-informational?style=flat-square)

A Helm chart for Kubernetes

Clickhouse Keeper is a zookeeper-like service for ClickHouse.
It is used to store metadata and distribute it to ClickHouse servers.

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
