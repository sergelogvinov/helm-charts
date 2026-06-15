# skipper

![Version: 0.8.0](https://img.shields.io/badge/Version-0.8.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.27.1](https://img.shields.io/badge/AppVersion-v0.27.1-informational?style=flat-square)

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
| env | list | `[]` | Environment variables |
| args | list | `[]` | Skipper arguments |
| config | object | `{"default-filters-prepend":"enableAccessLog(2,4,5)->flowId()->xforward()"}` | Skipper config file body refs: https://opensource.zalando.com/skipper/tutorials/basics/#yaml-configuration |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.name | string | `""` |  |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podLabels | object | `{}` | Extra labels for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podSecurityContext | object | `{"fsGroup":9999,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":9999,"runAsNonRoot":true,"runAsUser":9999}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| hostNetwork | bool | `false` | Pod host network Use it only for performance reason |
| hostPort | object | `{"enabled":false,"ports":{"http":8080,"https":8443}}` | Service node port refs: https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport |
| ingressClass | string | `"skipper"` |  |
| ingressClassResource.enabled | bool | `false` |  |
| ingressClassResource.controllerValue | string | `"k8s.io/ingress-skipper"` |  |
| service.type | string | `"ClusterIP"` |  |
| service.annotations | object | `{}` |  |
| service.ipFamilies[0] | string | `"IPv4"` |  |
| resources.limits.cpu | int | `1` |  |
| resources.limits.memory | string | `"512Mi"` |  |
| resources.requests.cpu | string | `"100m"` |  |
| resources.requests.memory | string | `"128Mi"` |  |
| autoscaling | object | `{"controlledResources":["cpu","memory"],"controlledValues":"RequestsOnly","enabled":false,"maxAllowed":{},"maxReplicas":10,"minAllowed":{},"minReplicas":1,"targetCPUUtilizationPercentage":80,"updatePolicy":{"updateMode":"InPlaceOrRecreate"}}` | Horizontal and Vertical pod autoscaler. ref: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ |
| autoscaling.controlledResources | list | `["cpu","memory"]` | Resource to control Possible values are "cpu" and "memory" |
| autoscaling.controlledValues | string | `"RequestsOnly"` | Controls which resource value should be autoscaled Possible values are "RequestsAndLimits" and "RequestsOnly" |
| autoscaling.maxAllowed | object | `{}` | Max allowed resources for the pod default is resources.limits |
| autoscaling.minAllowed | object | `{}` | Min allowed resources for the pod default is resources.requests |
| autoscaling.updatePolicy | object | `{"updateMode":"InPlaceOrRecreate"}` | Update policy Possible values are "Off", "Initial", "Recreate", "InPlaceOrRecreate" and "Auto" |
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
