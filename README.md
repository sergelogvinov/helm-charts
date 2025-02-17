# Helm Charts

Add repo or you can use oci://ghcr.io

```shell
helm repo add sinextra https://helm-charts.sinextra.dev
helm repo update
```

Helm and OCI registry

```shell
# list helm chart versions
skopeo list-tags docker://ghcr.io/sergelogvinov/charts/${PKG_NAME}

# deploy
helm upgrade -i ${PKG_NAME} --version=${CHART_VERSION} oci://ghcr.io/sergelogvinov/charts/${PKG_NAME}
```

### Universal charts

* [backend-common](charts/backend-common/) - backend common deployment

### Common charts

* [bitwarden](charts/bitwarden/) - open source bitwarden (rust)
* [fluentd](charts/fluentd/) - fluentd log router
* [overprovisioner](charts/overprovisioner/) - reserve the resources for the deployment
* [registry-mirrors](charts/registry-mirrors/) - container registry mirrors
* [skipper](charts/skipper/) - skipper ingress controller

### Monitoring

* [victoria-metrics](charts/victoria-metrics/) - victoria metrics components (vmagent, vmalert, vmstorage)
* [prometheus-rules](charts/prometheus-rules/) - prometheus operator replacer

### Databases

* [clickhouse](charts/clickhouse/) - single node clickhouse
* [clickhouse-keeper](charts/clickhouse-keeper/)
* [tabix](charts/tabix/) - clickhouse web GUI
* [keydb](charts/keydb/) - master-master redis cluster
* [mongodb-backup](charts/mongodb-backup/) - mongo logical backup with restore checks
* [mongosqld](charts/mongosqld/) - mongo to sql gateway
* [mongosync](charts/mongosync/) - mongo replication
* [pgbouncer](charts/pgbouncer/) - postgres connection pooler
* [postgresql-single](charts/postgresql-single/) - postgres one node with backup/restore checks

### CICD

* [Github actions runner](charts/github-actions-runner/) - github actions runner
* [Teamcity](charts/teamcity/) - jetbrains teamcity

### P2P/VPN

* [openvpn](charts/openvpn/) - openvpn with/without OTP auth
* [ipsec](charts/ipsec/) - access kubernetes services throughth ipsec link
* [tailscale](charts/tailscale/) - exit-node mesh network

### Servics p2p links

* [link-common](charts/link-common/) - tool to link kubernetes services to p2p network
* [service-common](charts/service-common/) - tool to open services with TLS auth

### RnD

* [rbac-common](charts/rbac-common/) - predefined common RBAC policy

## Helm Charts best practices

Very often values which requared to check/fix:

```yaml
# Check security context, all helm charts already have default values
podSecurityContext:
  runAsNonRoot: true
  runAsUser: $ID
  runAsGroup: $ID
  fsGroup: $ID
  fsGroupChangePolicy: "OnRootMismatch"

securityContext:
  allowPrivilegeEscalation: false
  seccompProfile:
    type: RuntimeDefault
  capabilities:
    drop:
    - ALL

# adjust values, it already have default values
resources:
  limits:
    cpu: 1
    memory: 256Mi
  requests:
    cpu: 100m
    memory: 128Mi

# Define nodeSelector/nodeAffinity
nodeSelector:
  kubernetes.io/role: worker
```

## Test templates and charts

Helm charts consist of multiple resources that are to be deployed to the cluster.
It is essential to check that all the resources are created in the cluster with the correct values.
It is recommended to write tests for your charts and to run them after the installation.
For example, you can use the `helm test <release-name>` command to run tests
Alternatively, [helm unittest](https://github.com/helm-unittest/helm-unittest) is a BDD-styled unit testing framework for Helm charts as a Helm plugin.

## Generate documentation for charts

With *helm-docs* you can generate the *README* containing tables of values, versions, and description taken from *values.yaml* and *Chart.yaml*.
*helm-docs* can be integrated into [pre-commit](https://pre-commit.com/) along with linting.

Update the documentation manually for a chart:

```shell
# {PKG_NAME} is the name of the chart
make docs-${PKG_NAME}
```

## Keep the deployments idempotent

An idempotent operation is one you can apply many times without changing the result following the first run.
You can keep deployments idempotent by using `helm upgrade --install` command instead of `install` and `upgrade` separately.
It installs the charts if they are not already installed.
If they are already installed, it upgrades them.
Furthermore, you can use `--atomic` flag to rollback changes in the event of a failed operation during helm upgrade.
This ensures the Helm releases are not stuck in the failed state.

## Automatically roll deployments

It is common to have ConfigMaps or Secrets mounted to containers.
Although the deployments and container images change with new releases, the ConfigMaps or Secrets do not change frequently.
The *sha256sum* function can be used to ensure a deployment's annotation section is updated if another file changes:

```yaml
kind: Deployment
spec:
  template:
    metadata:
      annotations:
        checksum/config: {{ include (print $.Template.BasePath "/configmap.yaml") . | sha256sum }}
```

## Avoid privileged containers

Ensuring that a container can perform only a very limited set of operations is vital for production deployments.
This is possible thanks to the use of non-root containers, which are executed by a user different from root.
You can restrict the container capabilities to the minimal required set using [securityContext.capabilities.drop](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-capabilities-for-a-container) option.
That way, in case your container is compromised, the range of action available to an attacker is limited.

## Limit container resources

By default, a container has no resource constraints and can use as much of a given resource as the host's kernel scheduler allows.
It's a good idea to limit the memory and CPU usage of your containers, especially if you're running multiple containers.
Beyond that, when a container is compromised, attackers may try to make use of the underlying host resources to perform malicious activity.
Set [resource requests and limits of Pods and containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) to minimize the impact of breaches for resource-intensive containers.

## Include health/liveness checks

[Health checks](https://cloud.google.com/blog/products/containers-kubernetes/kubernetes-best-practices-setting-up-health-checks-with-readiness-and-liveness-probes) are a simple way to let the system know if an instance of your app is working or not working.
Many applications running for long periods of time eventually transition to broken states and cannot recover except by being restarted.
By default, Kubernetes starts to send traffic to a pod when all the containers inside the pod start and restarts containers when they crash.

Try to avoid using liveliness probes for high load services.

## Store secrets encrypted

There are a few ways to store secrets securely in repositories:

* [helm-secrets](https://github.com/jkroepke/helm-secrets)
* [Mozilla's SOPS](https://github.com/mozilla/sops)
* [Hashicorp Vault](https://github.com/hashicorp/vault)
* [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets)


## Links

* [13 Best Practices for using Helm](https://codersociety.com/blog/articles/helm-best-practices)
* [Best Practices for Creating Production-Ready Helm charts](https://docs.bitnami.com/tutorials/production-ready-charts/)
* [Best practices for deploying to Kubernetes using Helm](https://itnext.io/best-practices-for-deploying-to-kubernetes-using-helm-73be1f3040d2)
* [Chart Development Tips and Tricks](https://helm.sh/docs/howto/charts_tips_and_tricks/)
* [Helm 101 for Developers](https://levelup.gitconnected.com/helm-101-for-developers-1c28e734937e)
* [Helm Best Practices and Recommendations](https://kodekloud.com/blog/helm-best-practices/)
* [Helm Chart - Development Guide](https://medium.com/swlh/helm-chart-development-guide-bbc525d3b448)
