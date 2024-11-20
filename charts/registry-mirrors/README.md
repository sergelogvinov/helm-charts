# registry-mirrors

![Version: 0.2.3](https://img.shields.io/badge/Version-0.2.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.8.3](https://img.shields.io/badge/AppVersion-2.8.3-informational?style=flat-square)

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
        endpoints:
          - https://mirrors.example.com/docker-io
      gcr.io:
        endpoints:
          - https://mirrors.example.com/gcr-io
      ghcr.io:
        endpoints:
          - https://mirrors.example.com/ghcr-io
      registry.k8s.io:
        endpoints:
          - https://mirrors.example.com/registry-k8s-io
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` |  |
| image.repository | string | `"registry"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| auth | object | `{"tls":false}` | Mirror tls auth |
| mirrors | list | `[{"host":"docker.io","source":"https://registry-1.docker.io"},{"host":"gcr.io","source":"https://gcr.io"},{"host":"ghcr.io","source":"https://ghcr.io"},{"host":"registry.k8s.io","source":"https://registry.k8s.io"}]` | Container mirrors |
| serviceAccount | object | `{"annotations":{},"create":false,"name":""}` | Pods Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podSecurityContext | object | `{"fsGroup":65534,"fsGroupChangePolicy":"OnRootMismatch","runAsNonRoot":true}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsGroup":65534,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| service | object | `{"ipFamilies":["IPv4"],"port":80,"type":"ClusterIP"}` | Service parameters ref: https://kubernetes.io/docs/user-guide/services/ |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","path":"/"}],"tls":[]}` | Mirror ingress parameters ref: http://kubernetes.io/docs/user-guide/ingress/ |
| resources | object | `{"requests":{"cpu":"50m","memory":"64Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"size":"1Gi"}` | Persistence parameters ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| updateStrategy | object | `{"type":"RollingUpdate"}` | pod deployment update strategy type. ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
