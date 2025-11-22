# fluentd

![Version: 1.4.1](https://img.shields.io/badge/Version-1.4.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.19.1](https://img.shields.io/badge/AppVersion-1.19.1-informational?style=flat-square)

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
| kubeVersion | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | Pods Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ example: `fluentbit.io/exclude: 'true'` |
| podSecurityContext | object | `{"fsGroup":101,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":101,"runAsNonRoot":true,"runAsUser":100}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| hostNetwork | bool | `false` | Use host's network namespace. ref: https://kubernetes.io/docs/concepts/policy/pod-security-policy/#host-namespaces |
| service | object | `{"annotations":{},"ipFamilies":["IPv4"],"ports":[{"containerPort":24224,"name":"fluentd","protocol":"TCP"},{"containerPort":24224,"name":"heartbeat","protocol":"UDP"}],"trafficDistribution":"","type":"ClusterIP"}` | Service parameters ref: https://kubernetes.io/docs/user-guide/services/ |
| service.type | string | `"ClusterIP"` | Service type ref: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types |
| service.annotations | object | `{}` | Annotations for service |
| service.ipFamilies | list | `["IPv4"]` | IP families for service possible values: IPv4, IPv6 ref: https://kubernetes.io/docs/concepts/services-networking/dual-stack/ |
| service.ports | list | `[{"containerPort":24224,"name":"fluentd","protocol":"TCP"},{"containerPort":24224,"name":"heartbeat","protocol":"UDP"}]` | Service ports |
| service.trafficDistribution | string | `""` | The traffic distribution for the service. possible values: PreferClose ref: https://kubernetes.io/docs/concepts/services-networking/service/#traffic-distribution |
| envs | object | `{}` | Deployment environment variables example: `FLUENTD_CONF: /fluentd/etc/fluent.conf` |
| env | list | `[]` | Deployment environment variables example: `- name: AWS_ACCESS_KEY_ID value: ABC` |
| logLevel | string | `"warn"` |  |
| inputCerts | object | `{"clients":["fluent-bit"],"create":false}` | Use tls connection for input port ref: https://docs.fluentd.org/input/forward |
| configMaps | object | `{"output.conf":"<match **>\n  @type stdout\n</match>\n"}` | Fluentd configuration ref: https://docs.fluentd.org/configuration |
| configMaps."output.conf" | string | `"<match **>\n  @type stdout\n</match>\n"` | Output rules |
| metrics | object | `{"enabled":false}` | Expose prometheus metrics |
| resources | object | `{"requests":{"cpu":"100m","memory":"128Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| useDaemonSet | bool | `false` | Use a daemonset instead of a deployment |
| updateStrategy | object | `{"rollingUpdate":{"maxUnavailable":1},"type":"RollingUpdate"}` | Pod deployment update strategy type. ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment |
| extraVolumes | list | `[]` |  |
| extraVolumeMounts | list | `[]` |  |
| priorityClassName | string | `nil` | Priority Class Name ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| podAntiAffinityPreset | string | `"soft"` | Pod Anti Affinity soft/hard |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
