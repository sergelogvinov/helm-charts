# link-common

![Version: 0.4.0](https://img.shields.io/badge/Version-0.4.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.8.6-alpine3.19](https://img.shields.io/badge/AppVersion-2.8.6--alpine3.19-informational?style=flat-square)

Simple vpn-p2p-link service

The main idea of the project is to make it easy to connect Kubernetes services through a wireguard tunnel.
This tunnel provides a secure way for external clients or other networks to access pre-defined services inside a Kubernetes cluster.

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/main/charts/link-common>

Example:

```yaml
service:
  ports:
    - name: postgres
      port: 5432
      backend: pg-backend.databases.svc.cluster.local:5432
    - name: mongo
      port: 27017
      backend: mongo-backend-rs0-0.mongo-backend-rs0.databases.svc.cluster.local:27017

wireguard:
  enabled: true

  wireguardIP: 172.30.1.161/32
  wireguardMTU: 1260
  wireguardKey: "your-private-key"

  peers:
    link-1:
      endpoint: 1.2.3.11:1191
      allowedIps: 172.30.1.21/32
      persistentKeepalive: 60
      publicKey: "your-public-key"
    link-2:
      endpoint: 1.2.3.12:1191
      allowedIps: 172.30.1.22/32
      persistentKeepalive: 60
      publicKey: "your-public-key"
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` |  |
| image.repository | string | `"ghcr.io/sergelogvinov/haproxy"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.name | string | `""` |  |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podSecurityContext | object | `{"fsGroup":99,"fsGroupChangePolicy":"OnRootMismatch"}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"add":["NET_BIND_SERVICE"],"drop":["ALL"]},"runAsGroup":99,"runAsNonRoot":true,"runAsUser":99,"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| service | object | `{"ipFamilies":["IPv4"],"ports":[],"type":"ClusterIP"}` | Service parameters ref: https://kubernetes.io/docs/concepts/services-networking/service/ |
| certManager.createCerts | bool | `false` |  |
| certManager.dnsName | string | `nil` |  |
| certManager.clients | list | `[]` |  |
| wireguard.enabled | bool | `false` |  |
| wireguard.image.repository | string | `"ghcr.io/sergelogvinov/wireguard"` |  |
| wireguard.image.pullPolicy | string | `"IfNotPresent"` |  |
| wireguard.image.tag | string | `"1.0.20210914"` |  |
| wireguard.wireguardIP | string | `"172.30.1.1/32"` |  |
| wireguard.wireguardMTU | int | `1280` |  |
| wireguard.wireguardPort | string | `nil` | WireGuard incoming port. uses as container hostPort. |
| wireguard.wireguardKey | string | `""` | WireGuard private key. ref: https://www.wireguard.com/quickstart/   wg genkey | tee privatekey | wg pubkey > publickey |
| wireguard.peers | object | `{}` |  |
| wireguard.metrics.enabled | bool | `true` | Enable link metrics |
| wireguard.metrics.image.repository | string | `"mindflavor/prometheus-wireguard-exporter"` |  |
| wireguard.metrics.image.pullPolicy | string | `"IfNotPresent"` |  |
| wireguard.metrics.image.tag | string | `"3.6.6"` |  |
| resources | object | `{"limits":{"cpu":"100m","memory":"64Mi"},"requests":{"cpu":"50m","memory":"32Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| networkPolicy.enabled | bool | `false` | Enable creation of NetworkPolicy resources ref: https://kubernetes.io/docs/concepts/services-networking/network-policies/ |
| networkPolicy.allowExternal | bool | `false` | Allow traffic from outside |
| networkPolicy.ingressNSMatchLabels | object | `{}` | Labels to match to allow traffic from other namespaces. |
| networkPolicy.ingressNSPodMatchLabels | object | `{}` | Pod labels to match to allow traffic from other namespaces |
| networkPolicy.metrics | object | `{"ingressNSMatchLabels":{},"ingressNSPodMatchLabels":{"app.kubernetes.io/component":"monitoring","app.kubernetes.io/name":"vmagent"}}` | NetworkPolicy for metrics. |
| networkPolicy.metrics.ingressNSMatchLabels | object | `{}` | Allowed from pods in namespaces that match the specified labels example: kubernetes.io/metadata.name: monitoring |
| networkPolicy.metrics.ingressNSPodMatchLabels | object | `{"app.kubernetes.io/component":"monitoring","app.kubernetes.io/name":"vmagent"}` | Allowed from pods that match the specified labels |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
