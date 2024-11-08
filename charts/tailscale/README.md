# tailscale

![Version: 0.2.6](https://img.shields.io/badge/Version-0.2.6-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.74.1](https://img.shields.io/badge/AppVersion-v1.74.1-informational?style=flat-square)

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

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` |  |
| image.repository | string | `"tailscale/tailscale"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| tailscale | object | `{}` |  |
| serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | Pods Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podSecurityContext | object | `{}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"capabilities":{"add":["NET_ADMIN","NET_RAW"],"drop":["ALL"]},"runAsNonRoot":false,"runAsUser":0,"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| service | object | `{"ipFamilies":["IPv4","IPv6"],"port":30025,"type":"NodePort"}` | Service parameters ref: https://kubernetes.io/docs/concepts/services-networking/service/ |
| service.port | int | `30025` | P2P endpoints port |
| service.ipFamilies | list | `["IPv4","IPv6"]` | P2P network family |
| resources | object | `{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"100m","memory":"256Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| dnsPolicy | string | `"Local"` | DNS Policy for pod ref: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/ ClusterFirst or Local |
| networkPolicy | object | `{"enabled":false}` | Network Policy parameters. ref: https://kubernetes.io/docs/concepts/services-networking/network-policies/ |
| useDaemonSet | bool | `false` | Use a daemonset instead of a deployment |
| updateStrategy | object | `{"rollingUpdate":{"maxUnavailable":1},"type":"RollingUpdate"}` | pod deployment update strategy type. ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
