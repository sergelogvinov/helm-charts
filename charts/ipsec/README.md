# ipsec

![Version: 0.6.3](https://img.shields.io/badge/Version-0.6.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 5.2](https://img.shields.io/badge/AppVersion-5.2-informational?style=flat-square)

IPSec link for Kubernetes

The main idea of the project is to make it easy to connect Kubernetes services through an IPsec tunnel.
This tunnel provides a secure way for external clients or other networks to access services inside a Kubernetes cluster.

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/main/charts/ipsec>
* <https://libreswan.org/>

Example:

```yaml
users:
  # openssl passwd -1 "password"
  user: $1$6GUtZDrw$ewnkkSXNY0mjTajRSlY5h.

secrets: |
  : PSK "ExampleSecret123"

# Exported service
# The 172.30.1.1:5432 will be available from the external network
ipsecService:
  enabled: true

  ip: 172.30.1.1
  ports:
    - name: postgres
      port: 5432
      backend: pg-backend.database.svc.cluster.local.

config: |
  conn xauth-psk
    pfs=no
    rekey=no
    ikev2=never
    keyingtries=5
    aggressive=no
    fragmentation=no
    cisco-unity=yes

    encapsulation=yes
    type=tunnel
    mtu=1300

    authby=secret
    xauthby=file

    ike=aes-sha1,aes-sha1;modp2048,aes-sha2;modp2048,aes256-sha2_512
    esp=aes-sha1,aes-sha2,aes256-sha2_512
    ikelifetime=24h
    salifetime=24h

    leftxauthserver=yes
    leftmodecfgserver=yes

    right=%any
    rightaddresspool=172.30.240.1-172.30.240.254
    rightxauthclient=yes
    rightmodecfgclient=yes

    also=service
    auto=add
    dpddelay=30
    dpdtimeout=120
    dpdaction=clear
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` |  |
| image.repository | string | `"ghcr.io/sergelogvinov/ipsec"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| envs | object | `{}` | Deployment envs |
| secrets | string | `"# openssl rand -base64 48\n%any 1.2.3.4 : PSK \"base64\"\n"` |  |
| users | object | `{}` | XAUTH openssl passwd -1 "$PASSWORD" |
| config | string | `"conn gcp\n    ikev2=yes\n    ikelifetime=600m\n    keylife=180m\n    rekeymargin=3m\n    keyingtries=3\n    ike=aes256-sha256-modp2048\n    esp=aes256-sha256-modp2048\n    pfs=yes\n"` |  |
| hostAliases | list | `[]` | host aliases ref: https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/ |
| ipsecService.enabled | bool | `false` |  |
| ipsecService.image.repository | string | `"ghcr.io/sergelogvinov/haproxy"` |  |
| ipsecService.image.pullPolicy | string | `"IfNotPresent"` |  |
| ipsecService.image.tag | string | `"3.3.4-alpine3.23"` |  |
| ipsecService.ip | string | `"10.10.10.10"` |  |
| ipsecService.networks | string | `"%v4:10.0.0.0/8,%v4:192.168.0.0/16,%v4:172.16.0.0/12,%v4:!172.30.240.0/24"` |  |
| ipsecService.ports | list | `[]` |  |
| serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | Pods Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| priorityClassName | string | `nil` | Priority Class Name ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| service | object | `{"ipFamilies":["IPv4"],"ipsec":4500,"isakmp":500,"type":"ClusterIP"}` | Service parameters ref: https://kubernetes.io/docs/user-guide/services/ |
| resources | object | `{"limits":{"cpu":"100m","memory":"128Mi"},"requests":{"cpu":"100m","memory":"64Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| useDaemonSet | bool | `false` | Use a daemonset instead of a deployment |
| updateStrategy | object | `{"rollingUpdate":{"maxUnavailable":1},"type":"RollingUpdate"}` | Pod deployment update strategy type. ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
