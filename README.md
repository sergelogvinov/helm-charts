# Helm Charts

Add repo:

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

## Common charts

* [bitwarden](charts/bitwarden/) - Open source bitwarden (rust)
* [clickhouse](charts/clickhouse/) - single node clickhouse
* [clickhouse-keeper](charts/clickhouse-keeper/)
* [fluentd](charts/fluentd/) - fluentd log router
* [keydb](charts/keydb/) - master-master redis cluster
* [mongodb-backup](charts/mongodb-backup/) - mongo logical backup with restore checks
* [mongosqld](charts/mongosqld/) - mongo to sql gateway
* [mongosync](charts/mongosync/) - mongo replication
* [pgbouncer](charts/pgbouncer/) - postgres connection pooler
* [postgresql-single](charts/postgresql-single/) - postgres one node with backup/restore checks
* [prometheus-rules](charts/prometheus-rules/) - prometheus operator replacer
* [registry-mirrors](charts/registry-mirrors/) - container registry mirrors
* [tabix](charts/tabix/) - clickhouse web GUI

## P2P/VPN

* [openvpn](charts/openvpn/) - openvpn with/without OTP auth
* [ipsec](charts/ipsec/) - access kubernetes services throughth ipsec link
* [tailscale](charts/tailscale/) - exit-node mesh network

## Servics p2p links

* [link-common](charts/link-common/) - tool to link kubernetes services to p2p network
* [service-common](charts/service-common/) - tool to open services with TLS auth

## RnD

* [rbac-common](charts/rbac-common/) - predefined common RBAC policy
