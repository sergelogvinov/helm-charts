# keydb

![Version: 0.20.1](https://img.shields.io/badge/Version-0.20.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 6.3.3](https://img.shields.io/badge/AppVersion-6.3.3-informational?style=flat-square)

KeyDB with TLS, backup/restore support

KeyDB is a high-performance, distributed NoSQL database that is designed to be compatible with the Redis protocol. In many ways, KeyDB can be considered a drop-in replacement for Redis, as it supports the same data structures and commands.

* TLS connections
* HaProxy load balances
* Master-master replication
* Support backup/restore to the extrernal storage, using [wal-g](https://github.com/wal-g)

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/master/charts/keydb>
* <https://docs.keydb.dev>
* <https://github.com/wal-g/wal-g>

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
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| backup.cleanPolicy | string | `"retain FULL 7"` |  |
| backup.enabled | bool | `false` |  |
| backup.recovery | bool | `false` |  |
| backup.resources.requests.cpu | string | `"100m"` |  |
| backup.resources.requests.memory | string | `"128Mi"` |  |
| backup.schedule | string | `"15 4 * * *"` |  |
| backup.walg | object | `{}` |  |
| backupCheck.affinity | object | `{}` |  |
| backupCheck.enabled | bool | `false` |  |
| backupCheck.nodeSelector | object | `{}` |  |
| backupCheck.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| backupCheck.persistence.annotations | object | `{}` |  |
| backupCheck.persistence.size | string | `"8Gi"` |  |
| backupCheck.resources.requests.cpu | string | `"100m"` |  |
| backupCheck.resources.requests.memory | string | `"128Mi"` |  |
| backupCheck.schedule | string | `"15 8 * * *"` |  |
| backupCheck.tolerations | list | `[]` |  |
| clusterDomain | string | `"cluster.local"` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"ghcr.io/sergelogvinov/keydb"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| keydb.activeReplica | string | `"yes"` |  |
| keydb.maxmemory | string | `nil` |  |
| keydb.maxmemoryPolicy | string | `"noeviction"` |  |
| keydb.multiMaster | string | `"yes"` |  |
| keydb.password | string | `nil` |  |
| keydb.replBacklogSize | string | `nil` |  |
| keydb.save[0] | string | `"900 1"` |  |
| keydb.save[1] | string | `"120 100000"` |  |
| keydb.threads | int | `2` |  |
| kubeVersion | string | `""` |  |
| livenessProbe | object | `{}` |  |
| loadbalancer.enabled | bool | `false` |  |
| loadbalancer.image.pullPolicy | string | `"IfNotPresent"` |  |
| loadbalancer.image.repository | string | `"haproxy"` |  |
| loadbalancer.image.tag | string | `"2.7.10-alpine3.18"` |  |
| loadbalancer.livenessProbe.initialDelaySeconds | int | `10` |  |
| loadbalancer.livenessProbe.periodSeconds | int | `60` |  |
| loadbalancer.livenessProbe.successThreshold | int | `1` |  |
| loadbalancer.livenessProbe.timeoutSeconds | int | `1` |  |
| loadbalancer.podAntiAffinityPreset | string | `"soft"` |  |
| loadbalancer.podSecurityContext.fsGroup | int | `99` |  |
| loadbalancer.podSecurityContext.runAsGroup | int | `99` |  |
| loadbalancer.podSecurityContext.runAsNonRoot | bool | `true` |  |
| loadbalancer.podSecurityContext.runAsUser | int | `99` |  |
| loadbalancer.readinessProbe | object | `{}` |  |
| loadbalancer.replicaCount | int | `1` |  |
| loadbalancer.resources.limits.cpu | string | `"500m"` |  |
| loadbalancer.resources.limits.memory | string | `"64Mi"` |  |
| loadbalancer.resources.requests.cpu | string | `"100m"` |  |
| loadbalancer.resources.requests.memory | string | `"32Mi"` |  |
| loadbalancer.service.annotations | object | `{}` | Extra annotations for load balancer service. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| loadbalancer.service.externalIPs | list | `[]` | Services external IPs. ref: https://kubernetes.io/docs/concepts/services-networking/service/#external-ips |
| loadbalancer.service.externalTrafficPolicy | string | `"Cluster"` | Traffic policies. ref: https://kubernetes.io/docs/reference/networking/virtual-ips/#traffic-policies |
| loadbalancer.service.internalTrafficPolicy | string | `"Cluster"` |  |
| loadbalancer.service.labels | object | `{}` | Extra labels for load balancer service. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| loadbalancer.type | string | `"static"` | Type of loadbalancer. Can be dynamic or static |
| metrics.enabled | bool | `false` |  |
| metrics.image.pullPolicy | string | `"IfNotPresent"` |  |
| metrics.image.repository | string | `"oliver006/redis_exporter"` |  |
| metrics.image.tag | string | `"v1.78.0"` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"enabled":false,"size":"10Gi"}` | Persistence parameters ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podAntiAffinityPreset | string | `"soft"` | Pod Anti Affinity soft/hard |
| podAntiAffinityPresetKey | string | `"kubernetes.io/hostname"` |  |
| podLabels | object | `{}` | Extra labels for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podSecurityContext | object | `{"fsGroup":999,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":999,"runAsNonRoot":true,"runAsUser":999}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| priorityClassName | string | `nil` | Priority Class Name ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass |
| readinessProbe.failureThreshold | int | `2` |  |
| readinessProbe.initialDelaySeconds | int | `30` |  |
| readinessProbe.periodSeconds | int | `30` |  |
| readinessProbe.successThreshold | int | `3` |  |
| readinessProbe.timeoutSeconds | int | `1` |  |
| replicaCount | int | `1` |  |
| resources | object | `{"requests":{"cpu":"10m","memory":"64Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| service | object | `{"annotations":{},"ipFamilies":["IPv4"],"trafficDistribution":"","type":"ClusterIP"}` | Service parameters ref: https://kubernetes.io/docs/user-guide/services/ |
| service.annotations | object | `{}` | Annotations for service |
| service.ipFamilies | list | `["IPv4"]` | IP families for service possible values: IPv4, IPv6 ref: https://kubernetes.io/docs/concepts/services-networking/dual-stack/ |
| service.trafficDistribution | string | `""` | The traffic distribution for the service. possible values: PreferClose, PreferSameZone, PreferSameNode ref: https://kubernetes.io/docs/concepts/services-networking/service/#traffic-distribution |
| service.type | string | `"ClusterIP"` | Service type ref: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types |
| serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | Pods Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| startupProbe.failureThreshold | int | `60` |  |
| startupProbe.initialDelaySeconds | int | `30` |  |
| startupProbe.periodSeconds | int | `10` |  |
| startupProbe.successThreshold | int | `1` |  |
| startupProbe.timeoutSeconds | int | `1` |  |
| terminationGracePeriodSeconds | int | `30` |  |
| tlsCerts.create | bool | `false` |  |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| updateStrategy | object | `{"type":"RollingUpdate"}` | pod deployment update strategy type. ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment |
