# Teamcity

## Introduction

This chart bootstraps the Teamcity deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `private-teamcity`:

```console
$ helm install sergelogvinov/teamcity --name private-teamcity
```

The command deploys teamcity on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `private-teamcity` deployment:

```console
$ helm delete private-teamcity
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the teamcity chart and their default values.

### Teamcity server

Parameter | Description | Default
--------- | ----------- | -------
`server.enabled` | if true, create teamcity server | `true`
`server.image.repository` | server container image repository | `sergelog/teamcity`
`server.image.tag` | server container image tag | `release_2020.1.3-2`
`server.image.pullPolicy` | server container image pull policy | `IfNotPresent`
`server.updateStrategy` | deployment strategy | `{ "type": "Recreate" }`
`server.podAnnotations` | annotations to be added to server pods | `{}` |
`server.podSecurityContext` | specify pod annotations in the pod security policy | `{fsGroup: 1000}` |
`server.securityContext` | custom [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) for Teamcity containers | `{runAsUser: 1000, runAsGroup: 1000}` |
`server.serviceAccount.create` | if true, create the server service account | `true`
`server.serviceAccount.name` | name of the server service account to use or create | `{{ teamcity.fullname }}`
`server.serviceAccount.annotations` | annotations for the server service account | `{}`
`server.resources` | server pod resource requests & limits | `{requests: {cpu: 500m, memory: 1Gi} }`
`server.nodeSelector` | node labels for server pod assignment | `{}`
`server.tolerations` | node taints to tolerate | `[]`
`server.affinity` | pod affinity | `{}`
`server.persistentVolume.enabled` | if true, server will create a Persistent Volume Claim | `true`
`server.persistentVolume.accessModes` | server data Persistent Volume access modes | `[ReadWriteOnce]`
`server.persistentVolume.annotations` | annotations for server Persistent Volume Claim | `{}`
`server.persistentVolume.existingClaim` | server data Persistent Volume existing claim name | `""`
`server.persistentVolume.size` | server data Persistent Volume size | `10Gi`
`server.persistentVolume.storageClass` | server data Persistent Volume Storage Class | `""`
`server.configDb` | server [database properties](https://www.jetbrains.com/help/teamcity/setting-up-an-external-database.html) | `""`
`ingress.enabled` | if true, teamcity server Ingress will be created | `false`
`ingress.annotations` | teamcity server Ingress annotations | `[]`
`ingress.hosts` | teamcity server Ingress hostnames | `[]`
`ingress.tls` | teamcity server Ingress https certs | `[]`
`service.port` | teamcity server service port | `80`
`service.type` | teamcity server service type | `ClusterIP`
`postgresql.enabled` | if true, the `stable/postgresql` chart is used | `false`
`postgresql.postgresqlDatabase` | the postgres database to use | `teamcity`
`postgresql.postgresqlUsername` | the postgres user to create | `teamcity`
`postgresql.postgresqlPassword` | the postgres user's password | `teamcity`

### Teamcity agent

Parameter | Description | Default
--------- | ----------- | -------
`agent.enabled` | if true, create teamcity agent | `true`
`agent.image.repository` | agent container image repository | `sergelog/teamcity-agent`
`agent.image.tag` | agent container image tag | `release_2020.1.3-2`
`agent.image.pullPolicy` | agent container image pull policy | `IfNotPresent`
`agent.replicaCount` | desired number of agent pods | `0`
`agent.updateStrategy` | deployment strategy | `{ "type": "Recreate" }`
`agent.podAnnotations` | annotations to be added to agent pods | `{}` |
`agent.podSecurityContext` | specify pod annotations in the pod security policy | `{fsGroup: 1000}` |
`agent.securityContext` | custom [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) for Teamcity agent containers | `{runAsUser: 1000, runAsGroup: 1000, runAsNonRoot: true}` |
`agent.serviceAccount.create` | if true, create the agent service account | `true`
`agent.serviceAccount.name` | name of the agent service account to use or create | `{{ teamcity.fullname }}-agent`
`agent.serviceAccount.annotations` | annotations for the agent service account | `{}`
`agent.resources` | agent pod resource requests & limits | `{requests: {cpu: 500m, memory: 512Mi} }`
`agent.nodeSelector` | node labels for agent pod assignment | `{}`
`agent.tolerations` | node taints to tolerate | `[]`
`agent.affinity` | pod affinity | `{}`
`agent.extraVolumeMounts` | extra volume mounts for the pod | `[]`
`agent.extraVolumes` | additional volumes for the pod | `[]`
`agent.envs` | agent environment variables | `{}`
`agent.rbac.create` | if true, create & use RBAC resources | `false`
`agent.rbac.rules` | RBAC rules | `[]`
