# rbac-binding

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

Kubernetes RBAC binding

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/main/charts/rbac-binding>

```yaml
roleBindings:
  default:
    developers:
      roles:
        - name: cluster:view
          kind: ClusterRole
      users:
        - name: oauthuser
    cicd:
      roles:
        - name: cluster:cicd
          kind: ClusterRole
        - name: cluster:cicd:ro
          kind: ClusterRole
      users:
        - name: sa-account
          namespace: default
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| groups | object | `{}` |  |
| roleBindings | object | `{}` |  |
