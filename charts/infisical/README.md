# infisical

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 3919393](https://img.shields.io/badge/AppVersion-3919393-informational?style=flat-square)

nfisical is the open-source platform for secrets, certificates, and privileged access management.

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/master/charts/infisical>
* <https://github.com/Infisical/infisical>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` | This will set the replicaset count refs: https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/ |
| image.repository | string | `"infisical/infisical"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` | This is for the secrets for pulling an image from a private repository ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| nameOverride | string | `""` | This is to override the chart name. |
| fullnameOverride | string | `""` |  |
| command | list | `[]` | Command Override default container command |
| env | list | `[]` | Environment variables |
| envSecrets | object | `{}` |  |
| serviceAccount | object | `{"annotations":{},"automount":false,"create":true,"name":""}` | Pods Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| podlabels | object | `{}` | Extra labels for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podSecurityContext | object | `{"fsGroup":1001,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":1001,"runAsNonRoot":true,"runAsUser":1001}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| service.type | string | `"ClusterIP"` |  |
| service.port | int | `80` |  |
| service.ipFamilies | list | `["IPv4"]` | IP families for service possible values: IPv4, IPv6 ref: https://kubernetes.io/docs/concepts/services-networking/dual-stack/ |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}],"tls":[]}` | This block is for setting up the ingress refs: https://kubernetes.io/docs/concepts/services-networking/ingress/ |
| resources | object | `{"requests":{"cpu":"100m","memory":"1Gi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| startupProbe | object | `{"failureThreshold":60,"initialDelaySeconds":10,"periodSeconds":5,"successThreshold":1,"timeoutSeconds":1}` | This is to setup the startup probes refs: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| livenessProbe | object | `{}` | This is to setup the liveness probes refs: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| readinessProbe | object | `{}` | This is to setup the readiness probes refs: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| autoscaling | object | `{"enabled":false,"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80}` | Horizontal pod autoscaler. ref: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ |
| volumes | list | `[]` | Additional volumes on the output Deployment definition. |
| volumeMounts | list | `[]` | Additional volumeMounts on the output Deployment definition. |
| podDisruptionBudget | object | `{"create":true,"minAvailable":1}` | Pod disruption budget |
| metrics | object | `{"enabled":false}` | Expose the metrics |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| podAntiAffinityPreset | string | `"soft"` | Pod Anti Affinity soft/hard |
| podAntiAffinityPresetKey | string | `"kubernetes.io/hostname"` |  |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
