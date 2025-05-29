# rbac-common

![Version: 0.3.3](https://img.shields.io/badge/Version-0.3.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.1](https://img.shields.io/badge/AppVersion-0.1.1-informational?style=flat-square)

Kubernetes RBAC

The chart automatically creates default roles and role bindings for users, either in a specific namespace or across the entire cluster.
It has default permissions for the admins, developers, and viewers.

- ClusterAdmins have permission to read everything and can also create, change, or delete less important resources. The default Kubernetes cluster-admin role is very powerful and can be risky if not used carefully.
- Developers can see all resources in the cluster and delete pods, but they cannot create or change any other resources.
- Viewers can only look at resources in the cluster but cannot make any changes.

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/main/charts/rbac-common>

```yaml
rbac:
  create: true
  singleNamespace: false

clusterAdmins:
  - admin-1

developers:
  - dev-1

viewers:
  - viewer-1
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| rbac.create | bool | `true` |  |
| rbac.singleNamespace | bool | `false` |  |
| viewers | list | `[]` |  |
| developers | list | `[]` |  |
| clusterAdmins | list | `[]` |  |
| superadminNamespaces | list | `[]` |  |
