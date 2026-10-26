# cloudflare-tunnel

![Version: 0.0.3](https://img.shields.io/badge/Version-0.0.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2026.10.3](https://img.shields.io/badge/AppVersion-2026.10.3-informational?style=flat-square)

Cloudflared tunnel deployment

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/master/charts/cloudflare-tunnel>
* <https://github.com/cloudflare/cloudflared>

## Network policy

Set `networkPolicy.enabled: true` to create an egress NetworkPolicy. It allows
cluster DNS on TCP/UDP port 53, tunnel connections on TCP/UDP port 7844, and HTTPS
on TCP port 443. Tunnel and HTTPS traffic can reach IPv4 destinations outside
`10.0.0.0/8`, `172.16.0.0/12`, and `192.168.0.0/16` (RFC1918), and any IPv6
destination on these ports.

```yaml
networkPolicy:
  enabled: true
  extraEgress:
    - to:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: default
          podSelector:
            matchLabels:
              app: origin
      ports:
        - port: 8080
          protocol: TCP
```

Enforcement requires a CNI that supports NetworkPolicy. Other policies selecting
these pods can allow additional traffic because Kubernetes NetworkPolicies are
additive. The policy is disabled by default.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` |  |
| image.repository | string | `"cloudflare/cloudflared"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| args | list | `[]` | Args for the container entrypoint |
| envs | object | `{}` | Secret environment variables. Uses if not set the envSecretName |
| env | list | `[]` | Deployment environment variables |
| serviceAccount | object | `{"annotations":{},"create":false,"name":""}` | Pods Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podSecurityContext | object | `{"fsGroup":65532,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":65532,"runAsNonRoot":true,"runAsUser":65532}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsGroup":65532,"runAsUser":65532,"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| networkPolicy | object | `{"dns":{"ipBlocks":[],"namespaceSelector":{"matchLabels":{"kubernetes.io/metadata.name":"kube-system"}},"podSelector":{"matchLabels":{"k8s-app":"kube-dns"}}},"enabled":false,"extraEgress":[]}` | Network Policy parameters. ref: https://kubernetes.io/docs/concepts/services-networking/network-policies/ |
| networkPolicy.enabled | bool | `false` | Enable egress filtering: allow cluster DNS, tunnel connections, and HTTPS. Add rules for origin services using extraEgress. |
| networkPolicy.dns.namespaceSelector | object | `{"matchLabels":{"kubernetes.io/metadata.name":"kube-system"}}` | Namespace selector for cluster DNS pods. |
| networkPolicy.dns.podSelector | object | `{"matchLabels":{"k8s-app":"kube-dns"}}` | Pod selector for cluster DNS (CoreDNS and kube-dns). |
| networkPolicy.dns.ipBlocks | list | `[]` | Additional DNS resolver CIDRs allowed on TCP/UDP port 53, for example a DNS service IP or NodeLocal DNS address. |
| networkPolicy.extraEgress | list | `[]` | Additional egress rules for origin services or other destinations. |
| resources | object | `{"limits":{"cpu":"500m","memory":"256Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| updateStrategy | object | `{"rollingUpdate":{"maxUnavailable":1},"type":"RollingUpdate"}` | Controller deployment update strategy type. ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment |
| nodeSelector | object | `{}` | Node labels for controller assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for controller assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| affinity | object | `{}` | Affinity for controller assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
