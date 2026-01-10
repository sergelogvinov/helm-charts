# teamcity

![Version: 0.10.2](https://img.shields.io/badge/Version-0.10.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2025.11.1](https://img.shields.io/badge/AppVersion-2025.11.1-informational?style=flat-square)

Teamcity on Kubernetes

TeamCity is a build management and CI/CD server from JetBrains.
Self-hosted version of TeamCity is available for free for small teams.
You can run TeamCity on Kubernetes using this Helm chart.

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/master/charts/teamcity>
* <https://www.jetbrains.com/teamcity>

Example:

```yaml
server:
  resources:
    limits:
      cpu: 4
      memory: 8Gi
    requests:
      cpu: 500m
      memory: 4Gi
  persistentVolume:
    storageClass: proxmox-xfs
    size: 20Gi

agent:
  replicaCount: 2

  resources:
    limits:
      cpu: 2
      memory: 1Gi
    requests:
      cpu: 500m
      memory: 512Mi

  envs:
    DOCKER_BUILDKIT: "1"
    GOOGLE_APPLICATION_CREDENTIALS: /home/buildagent/.gcp/sa.json

  # GCP service account key
  extraVolumeMounts:
    - name: gcp
      mountPath: /home/buildagent/.gcp

  extraVolumes:
    - name: gcp
      secret:
        secretName: gcp
        defaultMode: 432

# Add docker-in-docker to the Teamcity agent
dind:
  resources:
    limits:
      cpu: 2
      memory: 16Gi
    requests:
      cpu: 500m
      memory: 2Gi

  persistence:
    enabled: true

    storageClass: proxmox-xfs
    size: 150Gi

ingress:
  enabled: true

  hosts:
    - host: ci.example.com
      paths: ["/"]
  tls:
    - secretName: ci.example.com-ssl
      hosts:
        - ci.example.com
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| server.enabled | bool | `true` |  |
| server.replicaCount | int | `1` |  |
| server.clusterMode | bool | `false` | Teamcity server runs as cluster ref: https://www.jetbrains.com/help/teamcity/2024.07/multinode-setup.html |
| server.clusterResponsibilities[0] | string | `"CAN_PROCESS_BUILD_TRIGGERS"` |  |
| server.clusterResponsibilities[1] | string | `"CAN_PROCESS_USER_DATA_MODIFICATION_REQUESTS"` |  |
| server.clusterResponsibilities[2] | string | `"CAN_CHECK_FOR_CHANGES"` |  |
| server.clusterResponsibilities[3] | string | `"CAN_PROCESS_BUILD_MESSAGES"` |  |
| server.image | object | `{"pullPolicy":"IfNotPresent","repository":"ghcr.io/sergelogvinov/teamcity","tag":""}` | Teamcity container image |
| server.envs | object | `{}` | Teamcity server environment variables |
| server.configDb | string | `""` | Teamcity database properties ref: https://www.jetbrains.com/help/teamcity/setting-up-an-external-database.html |
| server.updateStrategy | object | `{"type":"Recreate"}` | pod deployment update strategy type. ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment |
| server.serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | Teamcity server Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| server.podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| server.podSecurityContext | object | `{"fsGroup":1000,"fsGroupChangePolicy":"OnRootMismatch"}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| server.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| server.resources | object | `{"requests":{"cpu":"500m","memory":"1Gi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| server.priorityClassName | string | `nil` | Priority Class Name ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass |
| server.persistentVolume | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"enabled":true,"existingClaim":"","size":"10Gi","storageClass":""}` | Persistence parameters ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| server.persistentVolume.annotations | object | `{}` | Teamcity data Persistent Volume Claim annotations |
| server.persistentVolume.accessModes | list | `["ReadWriteOnce"]` | Teamcity data Persistent Volume access modes ref: http://kubernetes.io/docs/user-guide/persistent-volumes/ |
| server.persistentVolume.size | string | `"10Gi"` | teamcity data Persistent Volume size |
| server.persistentVolume.storageClass | string | `""` | Teamcity data Persistent Volume Storage Class If defined, storageClassName: <storageClass> If set to "-", storageClassName: "", which disables dynamic provisioning If undefined (the default) or set to null, no storageClassName spec is   set, choosing the default provisioner.  (gp2 on AWS, standard on   GKE, AWS & OpenStack) |
| server.persistentVolume.existingClaim | string | `""` | Teamcity data Persistent Volume existing claim name If defined, PVC must be created manually before volume will be bound |
| server.nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| server.tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| server.affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| server.additionalContainers | list | `[]` | Additional containers to add to the server deployment ref: https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#Container |
| agent.enabled | bool | `true` |  |
| agent.image.repository | string | `"ghcr.io/sergelogvinov/teamcity"` |  |
| agent.image.pullPolicy | string | `"IfNotPresent"` |  |
| agent.image.tag | string | `""` |  |
| agent.replicaCount | int | `0` | Use a deployment if you want to start teamcity agents by yourself Teamcity can run agents by demand |
| agent.envs | object | `{}` | Teamcity agent environment variables |
| agent.updateStrategy | object | `{"type":"Recreate"}` | pod deployment update strategy type. ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment |
| agent.serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | Teamcity agent Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| agent.rbac | object | `{"create":false,"rules":[]}` | Teamcity agent RBAC permission. |
| agent.podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| agent.podSecurityContext | object | `{"fsGroup":1000,"fsGroupChangePolicy":"OnRootMismatch"}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| agent.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| agent.resources | object | `{"requests":{"cpu":"500m","memory":"512Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| agent.priorityClassName | string | `nil` | Priority Class Name ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass |
| agent.extraVolumeMounts | list | `[]` | Additional container volume mounts. |
| agent.extraVolumes | list | `[]` | Additional volumes. |
| agent.nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| agent.tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| agent.affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| dind.enabled | bool | `true` |  |
| dind.image | object | `{"pullPolicy":"IfNotPresent","repository":"docker","tag":"26.1-dind"}` | Docker in Docker image. ref: https://hub.docker.com/_/docker/tags?page=1&name=dind |
| dind.resources | object | `{"limits":{"cpu":1,"memory":"2Gi"},"requests":{"cpu":"500m","memory":"512Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| dind.extraVolumeMounts | list | `[]` | Additional container volume mounts. |
| dind.extraVolumes | list | `[]` | Additional volumes. |
| dind.persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"enabled":false,"size":"100Gi"}` | Persistence parameters for source code ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| service | object | `{"ipFamilies":["IPv4"],"port":80,"type":"ClusterIP"}` | Service parameters ref: https://kubernetes.io/docs/concepts/services-networking/service/ |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[]}],"tls":[]}` | Registry ingress parameters ref: http://kubernetes.io/docs/user-guide/ingress/ |
| ingress.enabled | bool | `false` | If true, teamcity Ingress will be created |
| ingress.className | string | `""` | Ingress controller class name |
| ingress.annotations | object | `{}` | Ingress annotations |
| ingress.hosts | list | `[{"host":"chart-example.local","paths":[]}]` | Ingress hosts configuration |
| ingress.tls | list | `[]` | Ingress TLS configuration |
| metrics | object | `{"enabled":false,"image":{"pullPolicy":"IfNotPresent","repository":"nginx","tag":"1.23.0-alpine"},"password":"prometheus","securityContext":{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsGroup":101,"runAsNonRoot":true,"runAsUser":101,"seccompProfile":{"type":"RuntimeDefault"}},"username":"prometheus"}` | Expose Teamcity server metrics |
| metrics.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsGroup":101,"runAsNonRoot":true,"runAsUser":101,"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| postgresql.enabled | bool | `false` |  |
| postgresql.postgresqlDatabase | string | `"teamcity"` |  |
| postgresql.postgresqlUsername | string | `"teamcity"` |  |
| postgresql.postgresqlPassword | string | `"teamcity"` |  |
