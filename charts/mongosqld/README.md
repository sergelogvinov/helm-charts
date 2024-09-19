# mongosqld

![Version: 0.3.4](https://img.shields.io/badge/Version-0.3.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.14.16](https://img.shields.io/badge/AppVersion-2.14.16-informational?style=flat-square)

Mongo to SQL bridge

MongoSQLD is a MongoDB connector for BI tools.
It allows you to use SQL queries to access MongoDB data.
It supports pre-defined or dynamic schemas.

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/master/charts/mongosqld>
* <https://www.mongodb.com/docs/bi-connector/current/reference/mongosqld>

MongoDB Connector for BI

## Create user

```shell
db.createUser({user: 'mongosql', pwd:"mongosql", roles: [{ 'role': 'read', 'db': 'db' },{ 'role': 'readWrite', 'db': 'dbSchema' }] })
```

## Deploy chart

```yaml
# Predefined schema
schemaMode: custom
schema:
  - db: db
    tables:
    - table: table
      collection: table
      pipeline: []
      columns:
      - Name: _id
        MongoType: bson.ObjectId
        SqlName: _id
        SqlType: objectid

auth:
  host: mongo-rs0:27017
  username: mongosql
  password: mongosql
  database: db
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` |  |
| image.repository | string | `"ghcr.io/sergelogvinov/mongosqld"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| tlsCerts | object | `{"create":true}` | Create tls certs |
| schemaMode | string | `"memory"` | Schema store type memory, auto, custom |
| schema | string | `nil` |  |
| config | string | `""` |  |
| auth | object | `{"database":"db","host":"mongo-backend-rs0:27017","password":"pass","username":"user"}` | Mongo connections params |
| args | list | `[]` | Mongosqld arguments example: `- --sampleNamespaces=contacts.addresses` |
| serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | Pods Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podSecurityContext | object | `{"fsGroup":65534,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":65534,"runAsNonRoot":true,"runAsUser":65534}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| service | object | `{"ipFamilies":["IPv4"],"port":3306,"type":"ClusterIP"}` | Service parameters ref: https://kubernetes.io/docs/user-guide/services/ |
| resources | object | `{"requests":{"cpu":"50m","memory":"64Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| priorityClassName | string | `nil` | Priority Class Name ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
