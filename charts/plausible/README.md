# plausible

![Version: 0.1.6](https://img.shields.io/badge/Version-0.1.6-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v2.1.5](https://img.shields.io/badge/AppVersion-v2.1.5-informational?style=flat-square)

Plausible Analytics

Plausible Analytics is an easy to use, lightweight (< 1 KB), open source and privacy-friendly alternative to Google Analytics.
It doesnt use cookies and is fully compliant with GDPR, CCPA and PECR.

**Homepage:** <https://plausible.io/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/main/charts/plausible>
* <https://github.com/plausible/analytics>

```yaml
# Helm values
config:
  # openssl rand -base64 48, it creates automatically if not set
  secretKeyBase: ""
  # openssl rand -base64 32, it creates automatically if not set
  totpVaultKey: ""

envs:
  # The database URL for the PostgreSQL/Clickhouse database.
  DATABASE_URL: "postgres://plausible:plausible@plausible-pg/plausible"
  CLICKHOUSE_DATABASE_URL: "http://clickhouse:clickhouse@clickhouse.logs.svc:8123/plausible"
  #
  DISABLE_REGISTRATION: invite_only
  ENABLE_EMAIL_VERIFICATION: "false"
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` |  |
| image.repository | string | `"ghcr.io/plausible/community-edition"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| config.secretKeyBase | string | `""` |  |
| config.totpVaultKey | string | `""` |  |
| envs.DATABASE_URL | string | `"postgres://plausible:plausible@plausible-pg/plausible"` |  |
| envs.CLICKHOUSE_DATABASE_URL | string | `"http://plausible:plausible@clickhouse.logs.svc:8123/plausible"` |  |
| envs.DISABLE_REGISTRATION | string | `"invite_only"` |  |
| envs.ENABLE_EMAIL_VERIFICATION | string | `"false"` |  |
| serviceAccount | object | `{"annotations":{},"automount":true,"create":true,"name":""}` | Pods Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podLabels | object | `{}` | Extra labels for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podSecurityContext | object | `{"fsGroup":999,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":9999,"runAsNonRoot":true,"runAsUser":9999}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| service | object | `{"annotations":{},"ipFamilies":["IPv4"],"port":80,"type":"ClusterIP"}` | Service parameters ref: https://kubernetes.io/docs/user-guide/services/ |
| service.type | string | `"ClusterIP"` | service type |
| service.port | int | `80` | service port |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}],"tls":[]}` | Plausible ingress parameters ref: http://kubernetes.io/docs/user-guide/ingress/ |
| resources | object | `{"requests":{"cpu":"100m","memory":"128Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| autoscaling | object | `{"enabled":false,"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80}` | Horizontal pod autoscaler. ref: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ |
| updateStrategy.type | string | `"RollingUpdate"` |  |
| updateStrategy.rollingUpdate.maxUnavailable | int | `1` |  |
| volumes | list | `[]` | Additional volumes on the output Deployment definition. |
| volumeMounts | list | `[]` | Additional volumeMounts on the output Deployment definition. |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| podAntiAffinityPreset | string | `"soft"` | Pod Anti Affinity soft/hard |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
