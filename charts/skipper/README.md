# skipper

![Version: 0.2.17](https://img.shields.io/badge/Version-0.2.17-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.22.115](https://img.shields.io/badge/AppVersion-v0.22.115-informational?style=flat-square)

Ingress controller for Kubernetes

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/main/charts/skipper>

```yaml
ingressClass: skipper
ingressClassResource:
  enabled: true
  name: skipper

# hostNetwork: true
hostPort:
  ports:
    http: 8080
    https: 8443

priorityClassName: system-cluster-critical

useDaemonSet: true
terminationGracePeriodSeconds: 120
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` |  |
| image.repository | string | `"ghcr.io/zalando/skipper"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.name | string | `""` |  |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podLabels | object | `{}` | Extra labels for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podSecurityContext | object | `{"fsGroup":9999,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":9999,"runAsNonRoot":true,"runAsUser":9999}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| hostNetwork | bool | `false` |  |
| hostPort.enabled | bool | `false` |  |
| hostPort.ports.http | int | `8080` |  |
| hostPort.ports.https | int | `8443` |  |
| ingressClass | string | `"skipper"` |  |
| ingressClassResource.enabled | bool | `false` |  |
| ingressClassResource.controllerValue | string | `"k8s.io/ingress-skipper"` |  |
| service.type | string | `"ClusterIP"` |  |
| service.annotations | object | `{}` |  |
| service.ipFamilies[0] | string | `"IPv4"` |  |
| resources.requests.cpu | string | `"100m"` |  |
| resources.requests.memory | string | `"128Mi"` |  |
| autoscaling | object | `{"enabled":false,"maxReplicas":10,"minReplicas":1,"targetCPUUtilizationPercentage":80}` | Horizontal pod autoscaler. ref: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ |
| useDaemonSet | bool | `false` | Use a daemonset instead of a deployment |
| terminationGracePeriodSeconds | int | `120` |  |
| updateStrategy.type | string | `"RollingUpdate"` |  |
| updateStrategy.rollingUpdate.maxUnavailable | int | `1` |  |
| priorityClassName | string | `nil` | Priority Class Name ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass |
| volumes | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| podAntiAffinityPreset | string | `"soft"` | Pod Anti Affinity soft/hard |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| metrics.enabled | bool | `false` |  |
