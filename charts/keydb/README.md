# keydb

![Version: 0.6.2](https://img.shields.io/badge/Version-0.6.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 6.3.3](https://img.shields.io/badge/AppVersion-6.3.3-informational?style=flat-square)

KeyDB with TLS, backup/restore support

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/master/charts/keydb>
* <https://docs.keydb.dev>
* <https://github.com/wal-g/wal-g>

KeyDB is a high-performance, distributed NoSQL database that is designed to be compatible with the Redis protocol. In many ways, KeyDB can be considered a drop-in replacement for Redis, as it supports the same data structures and commands.

* TLS connections
* HaProxy load balances
* Master-master replication
* Support backup/restore to the extrernal storage, using [wal-g](https://github.com/wal-g)

```yaml
# helm values

replicaCount: 2

updateStrategy:
  type: OnDelete

tlsCerts:
  create: true

loadbalancer:
  enabled: true

extraVolumes:
  - name: certs
    secret:
      defaultMode: 256
      secretName: backup-s3
extraVolumeMounts:
  - name: certs
    mountPath: /home/redis/.aws
    readOnly: true

backup:
  enabled: true
  recovery: true

  walg:
    WALG_TAR_DISABLE_FSYNC: true
    WALG_COMPRESSION_METHOD: brotli
    WALG_S3_PREFIX: s3://backup/redis-backup

metrics:
  enabled: true
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` |  |
| image.repository | string | `"ghcr.io/sergelogvinov/keydb"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| clusterDomain | string | `"cluster.local"` |  |
| keydb.password | string | `nil` |  |
| keydb.threads | int | `2` |  |
| keydb.activeReplica | string | `"yes"` |  |
| keydb.multiMaster | string | `"yes"` |  |
| keydb.save[0] | string | `"900 1"` |  |
| keydb.save[1] | string | `"120 100000"` |  |
| tlsCerts.create | bool | `false` |  |
| loadbalancer.enabled | bool | `false` |  |
| loadbalancer.type | string | `"static"` | Type of loadbalancer. Can be dynamic or static |
| loadbalancer.replicaCount | int | `1` |  |
| loadbalancer.image.repository | string | `"haproxy"` |  |
| loadbalancer.image.pullPolicy | string | `"IfNotPresent"` |  |
| loadbalancer.image.tag | string | `"2.7.10-alpine3.18"` |  |
| loadbalancer.podSecurityContext.runAsNonRoot | bool | `true` |  |
| loadbalancer.podSecurityContext.runAsUser | int | `99` |  |
| loadbalancer.podSecurityContext.runAsGroup | int | `99` |  |
| loadbalancer.podSecurityContext.fsGroup | int | `99` |  |
| loadbalancer.resources.limits.cpu | string | `"100m"` |  |
| loadbalancer.resources.limits.memory | string | `"64Mi"` |  |
| loadbalancer.resources.requests.cpu | string | `"50m"` |  |
| loadbalancer.resources.requests.memory | string | `"32Mi"` |  |
| loadbalancer.livenessProbe.initialDelaySeconds | int | `10` |  |
| loadbalancer.livenessProbe.timeoutSeconds | int | `1` |  |
| loadbalancer.livenessProbe.successThreshold | int | `1` |  |
| loadbalancer.livenessProbe.periodSeconds | int | `60` |  |
| loadbalancer.readinessProbe | object | `{}` |  |
| loadbalancer.podAntiAffinityPreset | string | `"soft"` |  |
| backup.enabled | bool | `false` |  |
| backup.recovery | bool | `false` |  |
| backup.walg | object | `{}` |  |
| backup.schedule | string | `"15 4 * * *"` |  |
| backup.cleanPolicy | string | `"retain FULL 7"` |  |
| backup.resources.requests.cpu | string | `"100m"` |  |
| backup.resources.requests.memory | string | `"128Mi"` |  |
| backupCheck.enabled | bool | `false` |  |
| backupCheck.schedule | string | `"15 8 * * *"` |  |
| backupCheck.resources.requests.cpu | string | `"100m"` |  |
| backupCheck.resources.requests.memory | string | `"128Mi"` |  |
| backupCheck.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| backupCheck.persistence.size | string | `"8Gi"` |  |
| backupCheck.persistence.annotations | object | `{}` |  |
| backupCheck.nodeSelector | object | `{}` |  |
| backupCheck.tolerations | list | `[]` |  |
| backupCheck.affinity | object | `{}` |  |
| metrics.enabled | bool | `false` |  |
| metrics.image.repository | string | `"oliver006/redis_exporter"` |  |
| metrics.image.pullPolicy | string | `"IfNotPresent"` |  |
| metrics.image.tag | string | `"v1.51.0"` |  |
| serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | Pods Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| podLabels | object | `{}` | Extra labels for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podSecurityContext | object | `{"fsGroup":999,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":999,"runAsNonRoot":true,"runAsUser":999}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| priorityClassName | string | `nil` | Priority Class Name ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass |
| terminationGracePeriodSeconds | int | `30` |  |
| livenessProbe | object | `{}` |  |
| readinessProbe.initialDelaySeconds | int | `15` |  |
| readinessProbe.timeoutSeconds | int | `1` |  |
| readinessProbe.failureThreshold | int | `2` |  |
| readinessProbe.successThreshold | int | `2` |  |
| readinessProbe.periodSeconds | int | `30` |  |
| startupProbe.initialDelaySeconds | int | `10` |  |
| startupProbe.timeoutSeconds | int | `1` |  |
| startupProbe.failureThreshold | int | `60` |  |
| startupProbe.successThreshold | int | `1` |  |
| startupProbe.periodSeconds | int | `10` |  |
| service | object | `{"annotations":{},"ipFamilies":["IPv4"],"type":"ClusterIP"}` | Service parameters ref: https://kubernetes.io/docs/user-guide/services/ |
| resources | object | `{"requests":{"cpu":"10m","memory":"64Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"enabled":false,"size":"10Gi"}` | Persistence parameters ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| updateStrategy | object | `{"type":"RollingUpdate"}` | pod deployment update stategy type. ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| podAntiAffinityPreset | string | `"soft"` | Pod Anti Affinity soft/hard |
| podAntiAffinityPresetKey | string | `"kubernetes.io/hostname"` |  |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.2](https://github.com/norwoodj/helm-docs/releases/v1.11.2)
