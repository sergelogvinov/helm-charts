# github-actions-runner

![Version: 1.4.2](https://img.shields.io/badge/Version-1.4.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.311.0](https://img.shields.io/badge/AppVersion-2.311.0-informational?style=flat-square)

Github Actions with container registry and mirrors

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/master/charts/github-actions-runner>
* <https://github.com/actions/actions-runner-controller.git>

```yaml
# helm values

maxRunners: 8
minRunners: 1

githubConfigUrl: https://github.com/...
githubConfigSecret:
  github_app_id: "123"
  github_app_installation_id: "123"
  github_app_private_key: |
    KEY

controllerServiceAccount:
  name: arc

envs:
  BUILDKIT_PROGRESS: plain
  DOCKER_BUILDKIT: "1"

persistence:
  enabled: true
  storageClass: local-path
  size: 16Gi

mirrors:
  persistence:
    enabled: true
    storageClass: local-path
    size: 150Gi

registry:
  persistence:
    enabled: true
    storageClass: local-path
    size: 200Gi

  nodeSelector:
    node-role.kubernetes.io/builder: ""

nodeSelector:
  node-role.kubernetes.io/builder: ""
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.repository | string | `"ghcr.io/sergelogvinov/github-actions-runner"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| maxRunners | int | `8` |  |
| minRunners | int | `1` |  |
| runnerGroup | string | `"default"` |  |
| runnerScaleSetName | string | `""` |  |
| runnerVersion | string | `"0.6.1"` |  |
| githubConfigUrl | string | `"https://github.com/..."` |  |
| githubConfigSecret | object | `{}` |  |
| controllerServiceAccount.name | string | `"arc"` |  |
| dind.enabled | bool | `true` |  |
| dind.image.repository | string | `"docker"` |  |
| dind.image.pullPolicy | string | `"IfNotPresent"` |  |
| dind.image.tag | string | `"23.0-dind"` |  |
| dind.resources | object | `{"limits":{"cpu":1,"memory":"1Gi"},"requests":{"cpu":"500m","memory":"256Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| dind.persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"enabled":false,"size":"100Gi"}` | Persistence parameters for source code ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| mirrors.enabled | bool | `true` |  |
| mirrors.image.repository | string | `"ghcr.io/project-zot/zot-linux-amd64"` |  |
| mirrors.image.pullPolicy | string | `"IfNotPresent"` |  |
| mirrors.image.tag | string | `"v2.0.0-rc7"` |  |
| mirrors.registry | list | `[{"host":"docker.io","source":"https://registry-1.docker.io"},{"host":"gcr.io","source":"https://gcr.io"},{"host":"ghcr.io","source":"https://ghcr.io"},{"host":"quay.io","source":"https://quay.io"},{"host":"mcr.microsoft.com","source":"https://mcr.microsoft.com"},{"host":"registry.k8s.io","source":"https://registry.k8s.io"}]` | Container registry list. ref: https://docs.docker.com/registry/recipes/mirror/ |
| mirrors.resources | object | `{"limits":{"cpu":"500m","memory":"4Gi"},"requests":{"cpu":"100m","memory":"512Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| mirrors.persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"enabled":false,"size":"100Gi"}` | Persistence parameters for source code ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| mirrors.nodeSelector | object | `{}` | Node labels for mirrors deploy assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| mirrors.tolerations | list | `[]` | Tolerations for mirrors deploy assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| mirrors.affinity | object | `{}` | Affinity for mirrors deploy assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| registry.enabled | bool | `true` |  |
| registry.image.repository | string | `"registry"` |  |
| registry.image.pullPolicy | string | `"IfNotPresent"` |  |
| registry.image.tag | float | `2.8` |  |
| registry.resources | object | `{"limits":{"cpu":1,"memory":"512Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| registry.extraVolumeMounts | list | `[]` |  |
| registry.extraVolumes | list | `[]` |  |
| registry.persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"enabled":false,"size":"100Gi"}` | Persistence parameters for source code ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| registry.nodeSelector | object | `{}` | Node labels for local registry deploy assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| registry.tolerations | list | `[]` | Tolerations for local registry deploy assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| registry.affinity | object | `{}` | Affinity for local registry deploy assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| registry.cleaner.image.repository | string | `"ghcr.io/sergelogvinov/deckschrubber"` |  |
| registry.cleaner.image.pullPolicy | string | `"IfNotPresent"` |  |
| registry.cleaner.image.tag | string | `"0.7.0"` |  |
| registry.cleaner.args[0] | string | `"-insecure"` |  |
| registry.cleaner.args[1] | string | `"-registry=https://{{ include \"github-actions-runner.fullname\" . }}-registry"` |  |
| registry.cleaner.args[2] | string | `"-day=1"` |  |
| registry.cleaner.args[3] | string | `"-repos=50"` |  |
| registry.cleaner.resources | object | `{"limits":{"cpu":"100m","memory":"128Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| metrics.enabled | bool | `true` |  |
| metrics.image.repository | string | `"ghcr.io/sergelogvinov/github-actions-exporter"` |  |
| metrics.image.pullPolicy | string | `"IfNotPresent"` |  |
| metrics.image.tag | string | `"v1.9.0-beta"` |  |
| metrics.resources | object | `{"limits":{"cpu":"100m","memory":"256Mi"},"requests":{"cpu":"50m","memory":"192Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| metrics.nodeSelector | object | `{}` | Node labels for local registry deploy assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| metrics.tolerations | list | `[]` | Tolerations for local registry deploy assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| metrics.affinity | object | `{}` | Affinity for local registry deploy assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | Pods Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podSecurityContext | object | `{}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsGroup":0,"runAsUser":1001,"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| service | object | `{"ipFamilies":["IPv4"]}` | Service parameters ref: https://kubernetes.io/docs/user-guide/services/ |
| resources | object | `{"requests":{"cpu":"200m","memory":"256Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"enabled":false,"size":"8Gi"}` | Persistence parameters for source code ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.3](https://github.com/norwoodj/helm-docs/releases/v1.11.3)
