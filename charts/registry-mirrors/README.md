# registry-mirrors

![Version: 2.0.6](https://img.shields.io/badge/Version-2.0.6-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v2.1.7](https://img.shields.io/badge/AppVersion-v2.1.7-informational?style=flat-square)

Container registry mirror

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/master/charts/registry-mirrors>

Example:

```yaml
auth:
  tls: true

# Registry by default:
mirrors:
  - host: docker.io
    source: https://registry-1.docker.io
  - host: gcr.io
    source: https://gcr.io
  - host: ghcr.io
    source: https://ghcr.io
  - host: registry.k8s.io
    source: https://registry.k8s.io

ingress:
  enabled: true
  hosts:
    - host: mirrors.example.com
      path: /
```

## Talos machine config

```yaml
machine:
  registries:
    config:
      mirrors.example.com:
        tls:
          clientIdentity:
            crt: BASE64-crt
            key: BASE64-key
    mirrors:
      docker.io:
        overridePath: true
        endpoints:
          - https://mirrors.example.com/v2/docker-io
      gcr.io:
        overridePath: true
        endpoints:
          - https://mirrors.example.com/v2/gcr-io
      ghcr.io:
        overridePath: true
        endpoints:
          - https://mirrors.example.com/v2/ghcr-io
      registry.k8s.io:
        overridePath: true
        endpoints:
          - https://mirrors.example.com/v2/registry-k8s-io
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` |  |
| image.repository | string | `"ghcr.io/project-zot/zot"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| auth | object | `{"tls":false}` | Mirror tls auth |
| mirrors | list | `[{"host":"docker.io","source":"https://registry-1.docker.io"},{"host":"quay.io","source":"https://quay.io"},{"host":"gcr.io","source":"https://gcr.io"},{"host":"ghcr.io","source":"https://ghcr.io"},{"host":"registry.k8s.io","source":"https://registry.k8s.io"}]` | Container mirrors |
| serviceAccount | object | `{"annotations":{},"create":false,"name":""}` | Pods Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podSecurityContext | object | `{"fsGroup":65534,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":65534,"runAsNonRoot":true,"runAsUser":65534}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsGroup":65534,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| service | object | `{"ipFamilies":["IPv4"],"port":80,"type":"ClusterIP"}` | Service parameters ref: https://kubernetes.io/docs/user-guide/services/ |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","path":"/"}],"tls":[]}` | Mirror ingress parameters ref: http://kubernetes.io/docs/user-guide/ingress/ |
| resources | object | `{"limits":{"cpu":1},"requests":{"cpu":"100m","memory":"512Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"size":"1Gi"}` | Persistence parameters ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| updateStrategy | object | `{"type":"RollingUpdate"}` | pod deployment update strategy type. ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
