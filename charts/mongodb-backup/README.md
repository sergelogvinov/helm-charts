# mongodb-backup

![Version: 1.0.1](https://img.shields.io/badge/Version-1.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 8.0.6](https://img.shields.io/badge/AppVersion-8.0.6-informational?style=flat-square)

Mongo backup with restore checks

The mongodb-backup chart provides a way to backup and restore a MongoDB database to an external storage using [wal-g](https://github.com/wal-g)

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/master/charts/mongodb-backup>
* <https://www.mongodb.com>
* <https://github.com/wal-g/wal-g>

* Support backup to the extrernal storage, using [wal-g](https://github.com/wal-g)
* Daily backup check by restoring process

```yaml
# helm values

auth:
  host: mongo-0.mongo-headless:27017/?authSource=admin

walg: |
  WALG_S3_PREFIX: s3://backup/mongo-backup

extraVolumes:
  - name: s3-secrets
    secret:
      defaultMode: 256
      secretName: backup-s3
extraVolumeMounts:
  - name: s3-secrets
    mountPath: /var/backups/.aws
    readOnly: true

backupCheck:
  enabled: true
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` |  |
| image.repository | string | `"ghcr.io/sergelogvinov/mongodb"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| schedule | string | `"0 1 * * *"` |  |
| cleanPolicy | string | `"retain 3 --retain-count 3"` |  |
| activeDeadlineSeconds | int | `3600` |  |
| backupCheck.enabled | bool | `false` |  |
| backupCheck.schedule | string | `"15 8 * * *"` |  |
| backupCheck.resources.limits.cpu | int | `2` |  |
| backupCheck.resources.limits.memory | string | `"1Gi"` |  |
| backupCheck.resources.requests.cpu | int | `2` |  |
| backupCheck.resources.requests.memory | string | `"512Mi"` |  |
| backupCheck.persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"size":"8Gi"}` | Persistence parameters ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| backupCheck.nodeSelector | object | `{}` | Node labels for backup check pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| backupCheck.tolerations | list | `[]` | Tolerations for backup check pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| backupCheck.affinity | object | `{}` | Affinity for backup check pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| auth.host | string | `"mongo-headless:27017/?authSource=admin"` |  |
| auth.username | string | `"root"` |  |
| auth.password | string | `"root"` |  |
| env | list | `[]` |  |
| walg | object | `{}` |  |
| serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | Pods Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| podLabels | object | `{}` | Extra labels for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podSecurityContext | object | `{"fsGroup":34,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":0,"runAsNonRoot":true,"runAsUser":34}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| resources | object | `{"requests":{"cpu":"500m","memory":"256Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"enabled":false,"existingClaim":"","size":"10Gi"}` | Persistence parameters ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
