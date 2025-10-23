# clickhouse

![Version: 0.10.7](https://img.shields.io/badge/Version-0.10.7-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 24.12.6](https://img.shields.io/badge/AppVersion-24.12.6-informational?style=flat-square)

Clickhouse chart for Kubernetes

Clickhouse is a fast open-source OLAP database management system.

Supports both Altinity and standalone (statefulset) installations.
Supports backup to the external storage, using [clickhouse-backup](https://github.com/Altinity/clickhouse-backup)
Periodically checks backups by schedule.

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/master/charts/clickhouse>
* <https://github.com/ClickHouse/ClickHouse>
* <https://hub.docker.com/r/clickhouse/clickhouse-server>

Example:

```yaml
# clickhouse.yaml

installationType: "standalone" # or "altinity"

clickhouse:
  users:
    - name: reader
      profile: reader
      quota: default
      # echo -n "reader" | shasum -a 256
      password: 3d0941964aa3ebdcb00ccef58b1bb399f9f898465e9886d5aec7f31090a0fb30

ingress:
  enabled: true
  hosts:
    - host: clickhouse.example.com
  tls:
    - secretName: clickhouse.example.com-tls
      hosts:
        - clickhouse.example.com

resources:
  limits:
    cpu: 2
    memory: 4Gi
  requests:
    cpu: 200m
    memory: 1Gi

persistence:
  enabled: true
  size: 10Gi

backup:
  enabled: true

  args:
    - create_remote
    - --schema

  envs:
    REMOTE_STORAGE: s3
  config:
    s3:
      bucket: backet-name
      path: clickhouse-backup
      storage_class: STANDARD
      endpoint: s3.amazonaws.com
      region: us-east-1
      concurrency: 2
      compression_level: 4
      compression_format: brotli

backupCheck:
  enabled: true

metrics:
  enabled: true
```

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
| installationType | string | `"standalone"` | Installation type can be "altinity" or "standalone" |
| clusterDomain | string | `"cluster.local"` | Cluster domain refs: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/ |
| serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | Pods Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| podlabels | object | `{}` | Extra labels for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podSecurityContext | object | `{"fsGroup":101,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":101,"runAsNonRoot":true,"runAsUser":101}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"add":[],"drop":["ALL"]},"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| service | object | `{"ipFamilies":["IPv4"],"type":"ClusterIP"}` | Service parameters ref: https://kubernetes.io/docs/user-guide/services/ |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":["/clickhouse"]}],"tls":[]}` | Clickhouse ingress parameters ref: http://kubernetes.io/docs/user-guide/ingress/ |
| resources | object | `{"requests":{"cpu":"500m","memory":"512Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| extraVolumes | list | `[]` | Additional volume mounts. |
| extraVolumeMounts | list | `[]` | Additional volumes. |
| persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"enabled":true,"size":"64Gi"}` | Persistence parameters ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| priorityClassName | string | `nil` | Priority Class Name ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass |
| updateStrategy | object | `{"type":"RollingUpdate"}` | pod deployment update strategy type. ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| backup.enabled | bool | `false` |  |
| backup.image.repository | string | `"altinity/clickhouse-backup"` |  |
| backup.image.pullPolicy | string | `"IfNotPresent"` |  |
| backup.image.tag | string | `"2.6.39"` |  |
| backup.schedule | string | `"15 4 * * *"` |  |
| backup.args | list | `[]` |  |
| backup.envs | object | `{}` |  |
| backup.config | object | `{}` |  |
| backup.resources | object | `{"limits":{"cpu":4,"memory":"512Mi"},"requests":{"cpu":"500m","memory":"256Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| backup.priorityClassName | string | `nil` | Priority Class Name ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass |
| backupCheck.enabled | bool | `false` |  |
| backupCheck.schedule | string | `"15 8 * * *"` |  |
| backupCheck.envs | object | `{}` |  |
| backupCheck.resources | object | `{"limits":{"cpu":1,"memory":"4Gi"},"requests":{"cpu":"100m","memory":"512Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| backupCheck.persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"size":"8Gi"}` | Persistence parameters ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| backupCheck.nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| backupCheck.tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| backupCheck.affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| cronjobs | object | `{}` |  |
| tlsCerts.create | bool | `false` |  |
| metrics.enabled | bool | `false` |  |
| storage | object | `{}` |  |
| clickhouse.name | string | `nil` | Clickhouse cluster name Use helm-chart name if empty |
| clickhouse.logLevel | string | `"information"` | Clickhouse log level ref: https://clickhouse.com/docs/en/operations/server-configuration-parameters/settings#logger trace, debug, information, warning, error |
| clickhouse.accessManagement | bool | `false` | Clickhouse SQL-driven Access Control refs: https://clickhouse.com/docs/en/operations/access-rights |
| clickhouse.users[0] | object | `{"name":"logger","password":"2686af9f25e1a64f5e9f7290c7e457aa06b616fb31d2b4331ff6fa0857661cd5","profile":"default","quota":"default"}` | Clickhouse read write user |
| clickhouse.users[1] | object | `{"accessManagement":false,"name":"reader","password":"3d0941964aa3ebdcb00ccef58b1bb399f9f898465e9886d5aec7f31090a0fb30","profile":"reader","quota":"default"}` | Clickhouse read only user |
| clickhouse.zookeeper | object | `{}` |  |
| clickhouse.collections | list | `[]` | Clickhouse named collections |
| clickhouse.envs | object | `{}` |  |
| clickhouse.customConfig | object | `{}` |  |
