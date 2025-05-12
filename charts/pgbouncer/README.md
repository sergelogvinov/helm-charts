# pgbouncer

![Version: 0.9.0](https://img.shields.io/badge/Version-0.9.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 16.9](https://img.shields.io/badge/AppVersion-16.9-informational?style=flat-square)

Postgres connection poller

PgBouncer is a lightweight connection pooler for PostgreSQL.
It is designed to manage and optimize database connections by limiting the number of active connections to a PostgreSQL database, which helps improve performance and resource usage, especially in high-traffic environments.

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/main/charts/pgbouncer>

```yaml
# helm values

userlist:
  # "username" "password"
  # "md5" + "md5(password + username)" // echo -n '1234admin' | md5 -> md545f2603610af569b6155c45067268c6b
  pgbouncer: password
  betmaster: md5$HASH

databases:
  betmaster:
    host: pg-0.pg-headless
    port: 5432
    user: username
    dbname: database
    poolmode: session

users:
  username2:
    poolmode: transaction

pgHbaConfiguration: |-
  hostssl all         all                   0.0.0.0/0       md5

serverSslMode: require
clientSslMode: require

updateStrategy:
  type: OnDelete

metrics:
  enabled: true
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` |  |
| image.repository | string | `"ghcr.io/sergelogvinov/pgbouncer"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` |  |
| kubeVersion | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| databases | object | `{}` |  |
| users | object | `{}` |  |
| userlist.pgbouncer | string | `"pgbouncer"` |  |
| pgHbaConfiguration | string | `"# host  database    user                  address        auth-method\nhost    all         all                   10.0.0.0/8     md5\nhostssl all         all                   0.0.0.0/0      md5"` |  |
| customSettings | object | `{}` |  |
| serverSslMode | string | `"allow"` | Server TLS configuration. ref: https://www.pgbouncer.org/config.html#server_tls_sslmode |
| serverSslSecret | string | `""` | Server TLS secret name (cert-manager). |
| serverSsl | object | `{}` | Server TLS secrets. ref: https://www.pgbouncer.org/config.html#server_tls_ca_file ca, cert, key: If you want to use your own certificates, you can provide them here. |
| clientSslMode | string | `"allow"` | Client TLS configuration. ref: https://www.pgbouncer.org/config.html#client_tls_sslmode |
| clientSslSecret | string | `""` |  |
| podLabels | object | `{}` | Extra labels for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podSecurityContext | object | `{"fsGroup":999,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":999,"runAsNonRoot":true,"runAsUser":999}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| service | object | `{"annotations":{},"ipFamilies":["IPv4"],"port":5432,"trafficDistribution":"","type":"ClusterIP"}` | Service parameters ref: https://kubernetes.io/docs/user-guide/services/ |
| service.type | string | `"ClusterIP"` | Service type ref: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types |
| service.port | int | `5432` | Service port |
| service.annotations | object | `{}` | Annotations for service |
| service.ipFamilies | list | `["IPv4"]` | IP families for service possible values: IPv4, IPv6 ref: https://kubernetes.io/docs/concepts/services-networking/dual-stack/ |
| service.trafficDistribution | string | `""` | The traffic distribution for the service. possible values: PreferClose ref: https://kubernetes.io/docs/concepts/services-networking/service/#traffic-distribution |
| resources | object | `{"limits":{"memory":"128Mi"},"requests":{"cpu":"100m","memory":"64Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| autoscaling | object | `{"enabled":false,"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80}` | Horizontal pod autoscaler. ref: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ |
| useDaemonSet | bool | `false` | Use a daemonset instead of a deployment |
| terminationGracePeriodSeconds | int | `240` |  |
| updateStrategy | object | `{"rollingUpdate":{"maxUnavailable":1},"type":"RollingUpdate"}` | pod deployment update strategy type. ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment |
| priorityClassName | string | `nil` | Priority Class Name ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| podAntiAffinityPreset | string | `"soft"` | Pod Anti Affinity soft/hard |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| metrics.enabled | bool | `false` |  |
| metrics.image.repository | string | `"jbub/pgbouncer_exporter"` |  |
| metrics.image.tag | string | `"v0.19.0"` |  |
| metrics.image.pullPolicy | string | `"IfNotPresent"` |  |
| metrics.resources.limits.cpu | string | `"100m"` |  |
| metrics.resources.limits.memory | string | `"32Mi"` |  |
| metrics.resources.requests.cpu | string | `"10m"` |  |
| metrics.resources.requests.memory | string | `"16Mi"` |  |
