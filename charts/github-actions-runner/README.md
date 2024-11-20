# github-actions-runner

![Version: 2.1.2](https://img.shields.io/badge/Version-2.1.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.321.0](https://img.shields.io/badge/AppVersion-2.321.0-informational?style=flat-square)

Github Actions with container registry and mirrors

Github Actions runners with:
- docker as sidecar for running docker-in-docker
- docker registry to cache images between builds
- oci mirror to pull images and avoid hitting rate limits
- http proxy to reduce external traffic

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/master/charts/github-actions-runner>
* <https://github.com/actions/actions-runner-controller.git>

Before starting, you need to deploy the controller:

```bash
helm upgrade -i arc oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller
```

Then, you can deploy the runner using the following values:

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
| autoscaling.enabled | bool | `false` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.maxReplicas | int | `9` |  |
| autoscaling.targetUtilizationPercentage | int | `90` |  |
| autoscaling.scaleDown.stabilizationWindowSeconds | int | `600` |  |
| autoscaling.scaleUp.stabilizationWindowSeconds | int | `30` |  |
| runnerGroup | string | `"default"` |  |
| runnerScaleSetName | string | `""` |  |
| runnerVersion | string | `"0.9.3"` |  |
| githubConfigUrl | string | `"https://github.com/..."` |  |
| githubConfigSecret | object | `{}` |  |
| controllerServiceAccount.name | string | `"arc"` |  |
| controllerServiceAccount.namespace | string | `""` |  |
| dind.enabled | bool | `true` |  |
| dind.image | object | `{"pullPolicy":"IfNotPresent","repository":"docker","tag":"26.1-dind"}` | Docker in Docker image. ref: https://hub.docker.com/_/docker/tags?page=1&name=dind |
| dind.resources | object | `{"limits":{"cpu":1,"memory":"1Gi"},"requests":{"cpu":"500m","memory":"256Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| dind.extraVolumeMounts | list | `[]` | Additional container volume mounts. |
| dind.extraVolumes | list | `[]` | Additional volumes. |
| dind.persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"enabled":false,"size":"100Gi"}` | Persistence parameters for source code ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| proxy.enabled | bool | `false` |  |
| proxy.image.repository | string | `"ubuntu/squid"` |  |
| proxy.image.pullPolicy | string | `"IfNotPresent"` |  |
| proxy.image.tag | string | `"4.13-21.10_beta"` |  |
| proxy.command[0] | string | `"/bin/sh"` |  |
| proxy.command[1] | string | `"/etc/proxy/proxy.sh"` |  |
| proxy.resources | object | `{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"100m","memory":"256Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| proxy.persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"enabled":false,"size":"10Gi"}` | Persistence parameters for source code ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| proxy.nodeSelector | object | `{}` | Node labels for mirrors deploy assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| proxy.tolerations | list | `[]` | Tolerations for mirrors deploy assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| proxy.podAntiAffinityPreset | string | `"soft"` | Anti-affinity for pod assignment. options: soft, hard, null |
| proxy.affinity | object | `{}` | Affinity for mirrors deploy assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| mirrors.enabled | bool | `true` |  |
| mirrors.image.repository | string | `"ghcr.io/project-zot/zot"` |  |
| mirrors.image.pullPolicy | string | `"IfNotPresent"` |  |
| mirrors.image.tag | string | `"v2.1.1"` |  |
| mirrors.registry | list | `[{"host":"docker.io","source":"https://registry-1.docker.io"},{"host":"gcr.io","source":"https://gcr.io"},{"host":"ghcr.io","source":"https://ghcr.io"},{"host":"registry.gitlab.com","source":"https://registry.gitlab.com"},{"host":"quay.io","source":"https://quay.io"},{"host":"mcr.microsoft.com","source":"https://mcr.microsoft.com"},{"host":"registry.k8s.io","source":"https://registry.k8s.io"}]` | Container registry list. ref: https://docs.docker.com/registry/recipes/mirror/ |
| mirrors.resources | object | `{"limits":{"cpu":1,"memory":"1Gi"},"requests":{"cpu":"200m","memory":"512Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| mirrors.persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"enabled":false,"size":"100Gi"}` | Persistence parameters for source code ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| mirrors.serviceAccount | object | `{"annotations":{},"create":false,"name":""}` | Registry Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| mirrors.nodeSelector | object | `{}` | Node labels for mirrors deploy assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| mirrors.tolerations | list | `[]` | Tolerations for mirrors deploy assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| mirrors.affinity | object | `{}` | Affinity for mirrors deploy assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| registry.enabled | bool | `false` |  |
| registry.image.repository | string | `"ghcr.io/project-zot/zot"` |  |
| registry.image.pullPolicy | string | `"IfNotPresent"` |  |
| registry.image.tag | string | `"v2.1.2-rc3"` |  |
| registry.storage | string | `nil` |  |
| registry.ingress | object | `{"annotations":{"nginx.ingress.kubernetes.io/proxy-body-size":0},"auth":{},"className":"","enabled":false,"hosts":[],"tls":null}` | Registry ingress parameters ref: http://kubernetes.io/docs/user-guide/ingress/ |
| registry.resources | object | `{"limits":{"cpu":1,"memory":"1024Mi"},"requests":{"cpu":"100m","memory":"512Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| registry.extraVolumeMounts | list | `[]` |  |
| registry.extraVolumes | list | `[]` |  |
| registry.persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"enabled":false,"size":"100Gi"}` | Persistence parameters for source code ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| registry.serviceAccount | object | `{"annotations":{},"create":false,"name":""}` | Registry Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| registry.nodeSelector | object | `{}` | Node labels for local registry deploy assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| registry.tolerations | list | `[]` | Tolerations for local registry deploy assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| registry.affinity | object | `{}` | Affinity for local registry deploy assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| metrics.enabled | bool | `false` |  |
| metrics.image.repository | string | `"ghcr.io/sergelogvinov/github-actions-exporter"` |  |
| metrics.image.pullPolicy | string | `"IfNotPresent"` |  |
| metrics.image.tag | string | `"v1.9.0-beta"` |  |
| metrics.resources | object | `{"limits":{"cpu":"100m","memory":"256Mi"},"requests":{"cpu":"50m","memory":"192Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| metrics.nodeSelector | object | `{}` | Node labels for local registry deploy assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| metrics.tolerations | list | `[]` | Tolerations for local registry deploy assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| metrics.affinity | object | `{}` | Affinity for local registry deploy assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| listener | object | `{"affinity":{},"nodeSelector":{},"tolerations":[]}` | Github Actions Runner Listener parameters |
| listener.nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| listener.tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| listener.affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | Pods Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podSecurityContext | object | `{}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsGroup":0,"runAsUser":1001,"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| service | object | `{"ipFamilies":["IPv4"]}` | Service parameters ref: https://kubernetes.io/docs/user-guide/services/ |
| resources | object | `{"requests":{"cpu":"200m","memory":"512Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"enabled":false,"size":"8Gi"}` | Persistence parameters for source code ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| extraVolumeMounts | list | `[]` | Additional container volume mounts. |
| extraVolumes | list | `[]` | Additional volumes. |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| podAntiAffinityPreset | string | `"soft"` | Anti-affinity for pod assignment. options: soft, hard, null |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
