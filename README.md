# Helm Charts

Add repo:

```shell
helm repo add sinextra https://helm-charts.sinextra.dev
helm repo update
```

* [clickhouse](charts/clickhouse/)
* [clickhouse-keeper](charts/clickhouse-keeper/)
* [fluentd](charts/fluentd/) - fluentd log router
* [keydb](charts/keydb/) - master-master redis cluster
* [mongodb-backup](charts/mongodb-backup/) - mongo logical backup with restore checks
* [mongosqld](charts/mongosqld/) - mongo to sql gateway
* [openvpn](charts/openvpn/) - openvpn with/without OTP auth
* [pgbouncer](charts/pgbouncer/) - postgres connection pooler
* [postgresql-single](charts/postgresql-single/) - postgres one node with backup/restore checks
* [prometheus-rules](charts/prometheus-rules/) - prometheus operator replacer
* [registry-mirrors](charts/registry-mirrors/) - container registry mirrors
* [tabix](charts/tabix/) - clickhouse web GUI
* [tailscale](charts/tailscale/) - exit-node mesh network
