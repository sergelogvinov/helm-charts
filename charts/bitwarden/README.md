# bitwarden

![Version: 0.6.0](https://img.shields.io/badge/Version-0.6.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.34.1](https://img.shields.io/badge/AppVersion-1.34.1-informational?style=flat-square)

A Helm chart to deploy Bitwarden.

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/master/charts/bitwarden>
* <https://github.com/dani-garcia/vaultwarden>

Example:

```yaml
# bitwarden.yaml

envs:
  SMTP_USERNAME: 'username'
  SMTP_PASSWORD: 'password'
  ADMIN_TOKEN: 'super-token'

config:
  SMTP_FROM_NAME: 'VaultWarden'
  SMTP_HOST: 'smtp.gmail.com'
  SMTP_SECURITY: starttls

ingress:
  enabled: true
  className: nginx
  hosts:
    - host: vault.example.com
  tls:
    - secretName: vault.example.com-tls
      hosts:
        - vault.example.com

persistence:
  enabled: true
  size: 10Gi
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` |  |
| image.repository | string | `"vaultwarden/server"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| envSecretName | string | `""` | Kubernetes Secrets Name resource for environment variables. if set, the secrets will be mounted as environment variables. |
| envs | object | `{"ADMIN_TOKEN":"token","DISABLE_ADMIN_TOKEN":"false","SMTP_PASSWORD":"password","SMTP_USERNAME":"username"}` | Secret environment variables. Uses if not set the envSecretName |
| envs.SMTP_USERNAME | string | `"username"` | smtp username |
| envs.SMTP_PASSWORD | string | `"password"` | smtp password |
| envs.ADMIN_TOKEN | string | `"token"` | Admin token, use `/vaultwarden hash` to encrypt password |
| envs.DISABLE_ADMIN_TOKEN | string | `"false"` | After creation, better to disable admin portal |
| config | object | `{"EXTENDED_LOGGING":true,"INVITATIONS_ALLOWED":true,"INVITATION_ORG_NAME":"Bitwarden","ORG_ATTACHMENT_LIMIT":1048576,"ROCKET_CLI_COLORS":"off","ROCKET_WORKERS":10,"SHOW_PASSWORD_HINT":false,"SIGNUPS_ALLOWED":false,"SIGNUPS_DOMAINS_WHITELIST":"domain.tld","SIGNUPS_VERIFY":false,"SMTP_FROM":"bitwarden-rs@domain.tld","SMTP_FROM_NAME":"Vault","SMTP_HOST":"smtp.domain.tld","SMTP_PORT":587,"SMTP_SECURITY":"starttls","USER_ATTACHMENT_LIMIT":1048576,"WEB_VAULT_ENABLED":true}` | Official documentation https://github.com/dani-garcia/vaultwarden/wiki/Configuration-overview |
| serviceAccount | object | `{"annotations":{},"create":false,"name":""}` | Pods Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podSecurityContext | object | `{"fsGroup":33,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":33,"runAsNonRoot":true,"runAsUser":33}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsGroup":33,"runAsUser":33,"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| service | object | `{"ipFamilies":["IPv4"],"port":80,"portWSocket":3012,"type":"ClusterIP"}` | Bitwarden service parameters ref: https://kubernetes.io/docs/user-guide/services/ |
| service.type | string | `"ClusterIP"` | service type |
| service.port | int | `80` | service port |
| service.portWSocket | int | `3012` | websocket service port |
| ingress | object | `{"annotations":{"nginx.ingress.kubernetes.io/limit-connections":"25","nginx.ingress.kubernetes.io/limit-rps":"15","nginx.ingress.kubernetes.io/proxy-body-size":"1024m","nginx.ingress.kubernetes.io/proxy-connect-timeout":"10","nginx.ingress.kubernetes.io/proxy-read-timeout":"1800","nginx.ingress.kubernetes.io/proxy-send-timeout":"1800"},"className":"nginx","enabled":false,"hosts":[{"host":"vault.local"}],"tls":[]}` | Bitwarden ingress parameters ref: http://kubernetes.io/docs/user-guide/ingress/ |
| resources | object | `{"limits":{"cpu":"500m","memory":"256Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"enabled":false,"size":"10Gi"}` | Persistence parameters ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| updateStrategy | object | `{"rollingUpdate":{"maxUnavailable":1},"type":"RollingUpdate"}` | Controller deployment update strategy type. ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment |
| nodeSelector | object | `{}` | Node labels for controller assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for controller assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| affinity | object | `{}` | Affinity for controller assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
