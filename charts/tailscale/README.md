# tailscale

![Version: 0.19.1](https://img.shields.io/badge/Version-0.19.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.102.5](https://img.shields.io/badge/AppVersion-1.102.5-informational?style=flat-square)

Tailscale mesh network.

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/main/charts/tailscale>
* <https://github.com/tailscale/tailscale>
* <https://tailscale.com>

Using a Tailscale exit node allows you to route traffic from your Tailscale network to the internet through a kubernetes nodes outside of your network. This can be useful for a variety of reasons, such as accessing geographically-restricted content or improving network performance.

## Prepare the nodes

Add to node config:

```yaml
allowed-unsafe-sysctls: net.ipv6.conf.all.forwarding
```

## Deploy

Install the Tailscale client on each Kubernetes `VPN` node role.

```shell
helm upgrade -i -n vpn -f vars/tailscale.yaml tailscale oci://ghcr.io/sergelogvinov/charts/tailscale
```

Helm values vars/tailscale.yaml

```yaml
# helm values
tailscale:
  # Tailscale authentication key
  TS_AUTH_KEY: tskey-auth-XXX
  TS_TAGS: tag:vpn

useDaemonSet: true
nodeSelector:
  node-role.kubernetes.io/vpn: ""

podSecurityContext:
  sysctls:
    - name: net.ipv6.conf.all.forwarding
      value: "1"
```

Result:
for each node will create a secret taiscale state.
You can rename the client on the Portal.
By default the nodes have name `$REGION-$NODE`

```shell
# kubectl -n vpn get pods
NAME              READY   STATUS     RESTARTS        AGE
tailscale-2bqk4   1/1     Running    0               46d
tailscale-484sl   1/1     Running    0               46d
...

# kubectl -n vpn get secrets
tailscale-node-1          Opaque               5      46d
tailscale-node-2          Opaque               6      46d
```

## Tailscale Access Controls

Tailscale acls https://login.tailscale.com/admin/acls

```json
{
	"tagOwners": {
		"tag:vpn": ["email-who-created-token"],
	},
	"autoApprovers": {
		// A device tagged security can advertise exit nodes that are auto-approved
		"exitNode": ["tag:vpn"],
	},

	// Access control lists.
	"acls": [
		{
			"action": "accept",
			"src":    ["autogroup:members"],
			"dst":    ["autogroup:internet:*"],
		},
	],
}
```

It's important to note that Tailscale exit nodes are intended for personal use only,
and should not be used for commercial purposes or to violate the terms of service of any websites or services you are accessing through the exit node.

## Network policy

The chart enables an egress NetworkPolicy by default. It allows cluster DNS on
TCP/UDP port 53 and IPv4 destinations outside `10.0.0.0/8`, `172.16.0.0/12`, and
`192.168.0.0/16` (RFC1918). IPv6 egress is allowed. Ingress is unaffected.
Cluster DNS is selected using `k8s-app: kube-dns` in the `kube-system` namespace;
customize the DNS selectors if your cluster uses different labels.

For NodeLocal DNS or a CNI that filters DNS traffic using the DNS service IP,
add the resolver address as a CIDR in `networkPolicy.dns.ipBlocks`:

```yaml
networkPolicy:
  dns:
    ipBlocks:
      - 169.254.20.10/32
```

Private service backends configured in `service.ports` require an explicit
exception in `networkPolicy.extraEgress`, for example:

```yaml
networkPolicy:
  extraEgress:
    - to:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: default
          podSelector:
            matchLabels:
              app: postgres
      ports:
        - port: 5432
          protocol: TCP
```

Set `networkPolicy.enabled: false` to disable the chart's policy. Enforcement
requires a CNI that supports NetworkPolicy. Other policies selecting these pods
can allow additional traffic because Kubernetes NetworkPolicies are additive.
See the [Kubernetes NetworkPolicy documentation](https://kubernetes.io/docs/concepts/services-networking/network-policies/).

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` |  |
| image.repository | string | `"ghcr.io/sergelogvinov/tailscale"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| debug.enabled | bool | `false` |  |
| tailscale | object | `{}` |  |
| tailscaleDNS.bind | string | `"127.0.0.1 ::1"` |  |
| serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | Pods Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podSecurityContext | object | `{}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| podTopology | object | `{"enabled":false}` | Add Pod Topology to the pod's hostname. |
| podTailscaleNat | object | `{"enabled":false,"image":{"pullPolicy":"IfNotPresent","repository":"ghcr.io/sergelogvinov/iptables","tag":"1.8.11-nft"}}` | Add Pod with iptables nat configuration. |
| podTailscaleNat.image | object | `{"pullPolicy":"IfNotPresent","repository":"ghcr.io/sergelogvinov/iptables","tag":"1.8.11-nft"}` | Container for iptables utils |
| terminationGracePeriodSeconds | int | `5` | The time in seconds that is allowed for a tailscale node to gracefully shutdown ref: https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks |
| securityContext | object | `{"capabilities":{"add":["NET_ADMIN","NET_RAW","MKNOD","SETUID","SETGID"],"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsNonRoot":false,"runAsUser":0,"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| service | object | `{"ipFamilies":["IPv4","IPv6"],"port":30025,"type":"NodePort"}` | Service parameters ref: https://kubernetes.io/docs/concepts/services-networking/service/ |
| service.port | int | `30025` | P2P endpoints port |
| service.ipFamilies | list | `["IPv4","IPv6"]` | P2P network family |
| resources | object | `{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"100m","memory":"256Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| dnsPolicy | string | `"Local"` | DNS Policy for pod ref: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/ ClusterFirst or Local |
| networkPolicy | object | `{"dns":{"ipBlocks":[],"namespaceSelector":{"matchLabels":{"kubernetes.io/metadata.name":"kube-system"}},"podSelector":{"matchLabels":{"k8s-app":"kube-dns"}}},"enabled":false,"extraEgress":[]}` | Network Policy parameters. ref: https://kubernetes.io/docs/concepts/services-networking/network-policies/ |
| networkPolicy.enabled | bool | `false` | Enable egress filtering: allow cluster DNS, the Kubernetes API, and non-RFC1918 destinations. |
| networkPolicy.dns.namespaceSelector | object | `{"matchLabels":{"kubernetes.io/metadata.name":"kube-system"}}` | Namespace selector for cluster DNS pods. |
| networkPolicy.dns.podSelector | object | `{"matchLabels":{"k8s-app":"kube-dns"}}` | Pod selector for cluster DNS (CoreDNS and kube-dns). |
| networkPolicy.dns.ipBlocks | list | `[]` | Additional DNS resolver CIDRs allowed on TCP/UDP port 53, for example a DNS service IP or NodeLocal DNS address. |
| networkPolicy.extraEgress | list | `[]` | Additional egress rules, for example to allow private peers or subnet destinations. |
| useDaemonSet | bool | `false` | Use a daemonset instead of a deployment |
| updateStrategy | object | `{"rollingUpdate":{"maxUnavailable":1},"type":"RollingUpdate"}` | pod deployment update strategy type. ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment |
| extraVolumeMounts | list | `[]` | Additional container volume mounts. |
| extraVolumes | list | `[]` | Additional volumes. |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
