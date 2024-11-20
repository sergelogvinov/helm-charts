# fluentd

![Version: 0.2.2](https://img.shields.io/badge/Version-0.2.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.17.1](https://img.shields.io/badge/AppVersion-1.17.1-informational?style=flat-square)

Deploy fluentd as log router

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/master/charts/fluentd>
* <https://www.fluentd.org>

Launch fluentd as log router.

This chart uses with fluent-bit chart.
Fluent-bit is gathering the logs, and sending to fluentd deploy (fluentd router).
When fluentd routes the traffic to different destinations.

```yaml
# helm values

annotations:
  fluentbit.io/exclude: "true"
  prometheus.io/scrape: "true"
  prometheus.io/port: "24231"

useDaemonSet: true

env:
  FLUENTD_CONF: /fluentd/etc/fluent.conf

configMaps:
  output.conf: |
    <match **>
      @type stdout
      <format>
        @type hash
      </format>
    </match>

metrics:
  enabled: true

nodeSelector:
  node-role.kubernetes.io/control-plane: ""
tolerations:
  - key: node-role.kubernetes.io/control-plane
    effect: NoSchedule
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` |  |
| image.repository | string | `"ghcr.io/sergelogvinov/fluentd"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | Pods Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podSecurityContext | object | `{"fsGroup":101,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":101,"runAsNonRoot":true,"runAsUser":100}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| hostNetwork | bool | `false` | Use host's network namespace. ref: https://kubernetes.io/docs/concepts/policy/pod-security-policy/#host-namespaces |
| service | object | `{"annotations":{},"ipFamilies":["IPv4"],"ports":[{"containerPort":24224,"name":"fluentd","protocol":"TCP"},{"containerPort":24224,"name":"heartbeat","protocol":"UDP"}],"type":"ClusterIP"}` | Service parameters ref: https://kubernetes.io/docs/user-guide/services/ |
| envs | object | `{}` | Deployment env, example: `FLUENTD_CONF: /fluentd/etc/fluent.conf` |
| logLevel | string | `"warn"` |  |
| configMaps."forward-input.conf" | string | `"<source>\n  @type forward\n  port 24224\n  bind 0.0.0.0\n</source>\n"` | Input rules |
| configMaps."output.conf" | string | `"<match **>\n  @type stdout\n</match>\n"` | Output rules |
| metrics | object | `{"enabled":false}` | Expose prometheus metrics |
| resources | object | `{"requests":{"cpu":"100m","memory":"128Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| useDaemonSet | bool | `false` | Use a daemonset instead of a deployment |
| updateStrategy | object | `{"rollingUpdate":{"maxUnavailable":1},"type":"RollingUpdate"}` | Pod deployment update strategy type. ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment |
| extraVolumes | list | `[]` |  |
| extraVolumeMounts | list | `[]` |  |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| podAntiAffinityPreset | string | `"soft"` | Pod Anti Affinity soft/hard |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
