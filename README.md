# Helm Charts

You can use this repository in two ways:

1. Add the Helm repository.
2. Pull/install charts directly from the OCI registry (`oci://ghcr.io`).

```shell
helm repo add sinextra https://helm-charts.sinextra.dev
helm repo update
```

Use charts from the OCI registry:

```shell
# list helm chart versions
skopeo list-tags docker://ghcr.io/sergelogvinov/charts/${PKG_NAME}

# deploy
helm upgrade -i ${PKG_NAME} --version=${CHART_VERSION} oci://ghcr.io/sergelogvinov/charts/${PKG_NAME}
```

### Universal charts

* [backend-common](charts/backend-common/) - common backend deployment

### Common charts

* [fluentd](charts/fluentd/) - Fluentd log router
* [overprovisioner](charts/overprovisioner/) - reserve resources for workloads
* [registry-mirrors](charts/registry-mirrors/) - container registry mirrors
* [skipper](charts/skipper/) - Skipper ingress controller

### Secrets management

* [bitwarden](charts/bitwarden/) - open source Bitwarden (Rust)
* [infisical](charts/infisical/) - Infisical secrets manager

### Monitoring

* [victoria-metrics](charts/victoria-metrics/) - VictoriaMetrics components (`vmagent`, `vmalert`, `vmstorage`)
* [victoria-metrics-storage](charts/victoria-metrics-storage/) - VictoriaMetrics storage cluster
* [prometheus-rules](charts/prometheus-rules/) - Prometheus Operator replacement rules

### Databases

* [clickhouse](charts/clickhouse/) - single-node ClickHouse, statefulset and altinity operator versions with backup/restore checks
* [clickhouse-keeper](charts/clickhouse-keeper/)
* [tabix](charts/tabix/) - ClickHouse web UI
* [keydb](charts/keydb/) - active-active Redis-compatible cluster
* [mongodb-backup](charts/mongodb-backup/) - MongoDB logical backup with restore checks
* [mongosqld](charts/mongosqld/) - MongoDB to SQL gateway
* [mongosync](charts/mongosync/) - MongoDB replication
* [pgbouncer](charts/pgbouncer/) - PostgreSQL connection pooler
* [postgresql-single](charts/postgresql-single/) - PostgreSQL (statefulset or CNPG version) with backup/restore checks

### CI/CD

* [github-actions-runner](charts/github-actions-runner/) - GitHub Actions runner
* [teamcity](charts/teamcity/) - JetBrains TeamCity

### P2P/VPN

* [openvpn](charts/openvpn/) - OpenVPN with or without OTP auth
* [ipsec](charts/ipsec/) - access Kubernetes services through an IPsec link
* [tailscale](charts/tailscale/) - exit-node mesh network

### Service P2P links

* [link-common](charts/link-common/) - tool to connect Kubernetes services to a P2P network
* [service-common](charts/service-common/) - tool to expose services with TLS auth

### Talos

* [talos-backup](charts/talos-backup/) - backup and restore etcd from Talos control plane
* [system-upgrade-controller](charts/system-upgrade-controller/) - system upgrade controller for Talos (rancher/system-upgrade-controller)

### RnD

* [rbac-common](charts/rbac-common/) - predefined common RBAC policy
* [rbac-binding](charts/rbac-binding/) - RBAC bindings for users and groups

## Values structure of the chart

The Deployment, DaemonSet, or StatefulSet usually has the same name as the chart.
Most parameters are defined at the root of `values.yaml`, similar to the output from `helm create`.

If a chart has multiple components, place each component in its own subtree.
Components can reuse common values from the root level.
Each component has an additional `app.kubernetes.io/component` label with the component name.

Example: in the PostgreSQL chart, `backup` and `backupCheck` can share the same `nodeSelector` from the root, or override it in their own subtree.

```yaml
backup:
  schedule: "0 0 * * *"
  retention: 7d

backupCheck:
  schedule: "0 1 * * *"

nodeSelector:
  kubernetes.io/role: worker
```

## Helm Charts best practices

Common values to check and adjust:

```yaml
# Review security context values. Charts already include defaults.
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

# Tune resources for your workload. Defaults are provided.
resources:
  limits:
    cpu: 1
    memory: 256Mi
  requests:
    cpu: 100m
    memory: 128Mi

# Pod autoscaling is available for some charts. VPA or HPA can be used.
# By default, for daemonsets and for database deployments VPA is used.
autoscaling:
  enabled: true

# Define nodeSelector/nodeAffinity when needed.
nodeSelector:
  topology.kubernetes.io/zone: us-east-1a
```

## Test templates and charts

Helm charts include multiple resources deployed to a cluster.
It is important to verify that all resources are created with the expected values.
Write tests for your charts and run them after installation.
You can run integration-style checks with `helm test <release-name>`.
For unit tests, [helm unittest](https://github.com/helm-unittest/helm-unittest) provides a BDD-style testing plugin for Helm charts.

## Generate documentation for charts

With *helm-docs*, you can generate chart *README* files with value tables, versions, and descriptions from *values.yaml* and *Chart.yaml*.
*helm-docs* can be integrated into [pre-commit](https://pre-commit.com/) along with linting.

To update documentation manually for one chart:

```shell
# {PKG_NAME} is the name of the chart
make docs-${PKG_NAME}
```

## Keep the deployments idempotent

An idempotent operation is one you can apply many times without changing the result following the first run.
You can keep deployments idempotent by using `helm upgrade --install` instead of running `install` and `upgrade` separately.
It installs charts if they are not already installed.
If they are already installed, it upgrades them.
You can also use the `--atomic` flag to roll back changes if an upgrade fails.
This ensures the Helm releases are not stuck in the failed state.

## Automatically roll deployments

It is common to have ConfigMaps or Secrets mounted to containers.
Although the deployments and container images change with new releases, the ConfigMaps or Secrets do not change frequently.
Use `sha256sum` in pod template annotations to trigger a rollout when a referenced file changes:

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
This is possible by running containers as non-root users.
You can restrict capabilities to the minimum required set using [securityContext.capabilities.drop](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-capabilities-for-a-container).
That way, in case your container is compromised, the range of action available to an attacker is limited.

## Limit container resources

By default, a container has no resource constraints and can use as much of a given resource as the host's kernel scheduler allows.
It's a good idea to limit the memory and CPU usage of your containers, especially if you're running multiple containers.
When a container is compromised, attackers may try to abuse underlying host resources.
Set [resource requests and limits for Pods and containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) to reduce the impact.

## Include health/liveness checks

[Health checks](https://cloud.google.com/blog/products/containers-kubernetes/kubernetes-best-practices-setting-up-health-checks-with-readiness-and-liveness-probes) are a simple way to let the system know if an instance of your app is working or not working.
Many applications running for long periods of time eventually transition to broken states and cannot recover except by being restarted.
By default, Kubernetes starts to send traffic to a pod when all the containers inside the pod start and restarts containers when they crash.

Try to avoid overly aggressive liveness probes for high-load services.

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
