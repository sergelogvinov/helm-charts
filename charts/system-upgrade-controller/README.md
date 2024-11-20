# system-upgrade-controller

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.14.2](https://img.shields.io/badge/AppVersion-v0.14.2-informational?style=flat-square)

System Upgrade Controller for Talos

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/main/charts/system-upgrade-contoller>

Example:

```yaml
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` | Replicaset count. ref: https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/ |
| image | object | `{"pullPolicy":"IfNotPresent","repository":"rancher/system-upgrade-controller","tag":""}` | Image details. ref: https://kubernetes.io/docs/concepts/containers/images/ |
| imagePullSecrets | list | `[]` | Secretes for pulling an image from a private repository. ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| envs | object | `{"SYSTEM_UPGRADE_CONTROLLER_DEBUG":false,"SYSTEM_UPGRADE_CONTROLLER_THREADS":2,"SYSTEM_UPGRADE_JOB_ACTIVE_DEADLINE_SECONDS":1800,"SYSTEM_UPGRADE_JOB_BACKOFF_LIMIT":1,"SYSTEM_UPGRADE_JOB_IMAGE_PULL_POLICY":"IfNotPresent","SYSTEM_UPGRADE_JOB_KUBECTL_IMAGE":"registry.k8s.io/kubectl:v1.31.2@sha256:d31de5468fb5c0943358671e3dcf8e4d8281108027efd1f211262d09aedd5519","SYSTEM_UPGRADE_JOB_PRIVILEGED":false,"SYSTEM_UPGRADE_JOB_TTL_SECONDS_AFTER_FINISH":900,"SYSTEM_UPGRADE_PLAN_POLLING_INTERVAL":"15m"}` | Environment variables |
| talosVersion | string | `"v1.8.3"` |  |
| plan.kubernetes.enabled | bool | `true` |  |
| plan.kubernetes.version | string | `"v1.31.2"` |  |
| serviceAccount | object | `{"annotations":{},"automount":true,"create":true,"name":""}` | Pods Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podLabels | object | `{}` | Labels for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podSecurityContext | object | `{"fsGroup":65534,"fsGroupChangePolicy":"OnRootMismatch"}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsGroup":65534,"runAsNonRoot":true,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| resources | object | `{"requests":{"cpu":"100m","memory":"128Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| volumes | list | `[]` | Additional container volume mounts. |
| volumeMounts | list | `[]` | Additional volumes. |
| updateStrategy | object | `{"rollingUpdate":{"maxUnavailable":1},"type":"RollingUpdate"}` | Deployment update strategy type. ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment |
| nodeSelector | object | `{"node-role.kubernetes.io/control-plane":""}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[{"effect":"NoSchedule","key":"node-role.kubernetes.io/control-plane","operator":"Exists"}]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
