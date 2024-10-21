# backend-common

![Version: 0.1.5](https://img.shields.io/badge/Version-0.1.5-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

Deploy common backend services with workers and jobs

This is a common chart for backend services.
It includes the following components:
- Deployment
- Job
- Service
- Ingress
- Horizontal Pod Autoscaler
- Pod Disruption Budget

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/main/charts/backend-common>

Example:

```yaml
# Default image for all components, can be overridden
image:
  repository: ghcr.io/sergelogvinov/backend-example

# Default replica count for all components, can be overridden
replicaCount: 1

services:
  # Deployment with service, default port is 5200
  admin:
    enabled: true
    command: ["uwsgi","--ini","settings/uwsgi.ini","--http11-socket",":5200"]

workers:
  # Deployment do not expose service
  celery-worker:
    enabled: true
    command: ["celery", "-A", "core.celery", "worker", "-l", "info"]

cronjobs:
  # Cronjob to run runcrons management command
  runcrons:
    enabled: true
    schedule: "5 * * * *"
    command: ["python", "manage.py", "runcrons"]

jobs:
  # Job to run migrations, runs by helm install or helm upgrade
  migrate:
    enabled: true
    command: ["python", "manage.py", "-p", "migrate", "--noinput"]
    # Override default resources values
    resources:
      limits:
        cpu: 1
        memory: 1024Mi
      requests:
        cpu: 500m
        memory: 256Mi

ingress:
  enabled: true
  hosts:
    - host: example.com
      paths:
        # Name is the service name
        - name: admin
          path: /admin
          pathType: ImplementationSpecific
        - name: admin
          path: /api
          pathType: ImplementationSpecific

# Default resources for all components
resources:
  limits:
    cpu: 1
    memory: 512Mi
  requests:
    cpu: 100m
    memory: 256Mi
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` |  |
| image.repository | string | `"nginx"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.automount | bool | `false` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.name | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.className | string | `""` |  |
| ingress.annotations | object | `{}` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].name | string | `"service"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| podSecurityContext.runAsUser | int | `1100` |  |
| podSecurityContext.runAsGroup | int | `1100` |  |
| podSecurityContext.fsGroup | int | `1100` |  |
| podSecurityContext.fsGroupChangePolicy | string | `"OnRootMismatch"` |  |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| priorityClassName | string | `nil` |  |
| secretsMountPath | string | `"/etc/secrets"` |  |
| secrets | object | `{}` |  |
| configMountPath | string | `"/etc/settings"` |  |
| configConfigMap | string | `nil` |  |
| config | string | `nil` |  |
| env | list | `[]` |  |
| envSecrets | object | `{}` |  |
| services | object | `{}` |  |
| workers | object | `{}` |  |
| cronjobs | object | `{}` |  |
| jobs | object | `{}` |  |
| resources.requests.cpu | string | `"100m"` |  |
| resources.requests.memory | string | `"256Mi"` |  |
| startupProbe.initialDelaySeconds | int | `30` |  |
| startupProbe.periodSeconds | int | `15` |  |
| startupProbe.timeoutSeconds | int | `10` |  |
| startupProbe.failureThreshold | int | `8` |  |
| livenessProbe.initialDelaySeconds | int | `120` |  |
| livenessProbe.periodSeconds | int | `60` |  |
| livenessProbe.timeoutSeconds | int | `10` |  |
| livenessProbe.failureThreshold | int | `5` |  |
| readinessProbe.initialDelaySeconds | int | `120` |  |
| readinessProbe.periodSeconds | int | `60` |  |
| readinessProbe.timeoutSeconds | int | `10` |  |
| readinessProbe.failureThreshold | int | `5` |  |
| volumes | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| nodeSelector | object | `{}` |  |
| tolerations | list | `[]` |  |
| affinity | object | `{}` |  |
| nodeAffinityPreset | object | `{}` |  |
| podAffinityPreset | object | `{}` |  |
| podAntiAffinityPreset | string | `"soft"` |  |
