# postgresql-single

![Version: 1.10.0](https://img.shields.io/badge/Version-1.10.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 16.11](https://img.shields.io/badge/AppVersion-16.11-informational?style=flat-square)

Postgres with backup/restore and replication

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/main/charts/postgresql-single>

A single-node PostgreSQL database is straightforward and relatively easy to maintain. You don't need to worry about configuring a distributed database or managing multiple nodes.

* Support backup/restore to the extrernal storage, using [wal-g](https://github.com/wal-g)
* Automatically tuning PostgreSQL parameters base on `postgresqlServerMemory` value.

```shell
# create backup-s3 secret
kubectl create secret generic backup-s3 --from-file=credentials
```

```yaml
# Helm values

installationType: standalone # or cnpg

pgHbaConfiguration:
  # host    database    user                  address       auth-method
  - hostssl app         app                   10.0.0.0/8    md5

postgresqlServerMemory: 2048
resources:
  limits:
    memory: 4Gi
    cpu: 4
  requests:
    memory: 2Gi
    cpu: 2

extraVolumes:
  - name: s3-certs
    secret:
      defaultMode: 256
      secretName: backup-s3
extraVolumeMounts:
  - name: s3-certs
    mountPath: /var/lib/postgresql/.aws
    readOnly: true

backup:
  enabled: true

  recovery: true # If PVC empty - it will use latest backup.

  walpush: true  # Send wal to the s3.
  walg:
    WALG_TAR_DISABLE_FSYNC: true
    WALG_UPLOAD_WAL_METADATA: INDIVIDUAL
    WALG_PREVENT_WAL_OVERWRITE: true
    WALG_COMPRESSION_METHOD: brotli
    WALG_LIBSODIUM_KEY_TRANSFORM: hex
    WALG_LIBSODIUM_KEY: "" # generate it: openssl rand -hex 32
    WALG_S3_PREFIX: s3://backup/postgrtes-backup

backupCheck:
  enabled: true

metrics:
  enabled: true
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` |  |
| image.repository | string | `"ghcr.io/sergelogvinov/postgresql"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| installationType | string | `"standalone"` | Installation type can be "cnpg" or "standalone" |
| command | list | `[]` | command Override default container command |
| env | list | `[]` | Environment variables |
| postgresqlUsername | string | `"postgres"` | PostgreSQL admin user ref: https://hub.docker.com/_/postgres |
| postgresqlMaxConnections | int | `150` | Create a database ref: https://hub.docker.com/_/postgres postgresqlDatabase: |
| pgHbaConfiguration | list | `[]` | Postgres auth ref: https://www.postgresql.org/docs/current/auth-pg-hba-conf.html |
| initdb.args | string | `"--data-checksums --auth-host=scram-sha-256"` | PostgreSQL initdb parameters ref: https://www.postgresql.org/docs/current/app-initdb.html |
| initdb.database | string | `"app"` | Create owner and database |
| initdb.username | string | `"app"` |  |
| initdb.password | string | `nil` |  |
| initdb.script | list | `[]` | PostgreSQL initdb scripts ref: https://hub.docker.com/_/postgres |
| tlsCerts.create | bool | `false` |  |
| tlsCerts.mode | string | `"require"` |  |
| pooler.enabled | bool | `false` |  |
| pooler.replicaCount | int | `1` |  |
| pooler.types[0] | string | `"rw"` |  |
| pooler.types[1] | string | `"ro"` |  |
| pooler.mode | string | `"session"` |  |
| pooler.parameters | object | `{}` |  |
| pooler.service.type | string | `"ClusterIP"` | Service type ref: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types |
| pooler.service.labels | object | `{}` | Extra labels for load balancer service. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| pooler.service.annotations | object | `{}` | Extra annotations for load balancer service. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| pooler.service.externalTrafficPolicy | string | `"Cluster"` | Traffic policies. ref: https://kubernetes.io/docs/reference/networking/virtual-ips/#traffic-policies |
| pooler.service.internalTrafficPolicy | string | `"Cluster"` |  |
| pooler.service.ipFamilies | list | `["IPv4"]` | IP families for service possible values: IPv4, IPv6 ref: https://kubernetes.io/docs/concepts/services-networking/dual-stack/ |
| pooler.resources.limits.cpu | string | `"500m"` |  |
| pooler.resources.limits.memory | string | `"64Mi"` |  |
| pooler.resources.requests.cpu | string | `"100m"` |  |
| pooler.resources.requests.memory | string | `"32Mi"` |  |
| pooler.priorityClassName | string | `nil` | Priority Class Name ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass |
| pooler.podAntiAffinityPreset | string | `"soft"` | Pod Anti Affinity soft/hard |
| pooler.podAntiAffinityPresetKey | string | `"kubernetes.io/hostname"` |  |
| pooler.nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| pooler.tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| pooler.affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| initContainers | list | `[]` |  |
| serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | Pods Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| podlabels | object | `{}` | Extra labels for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podSecurityContext | object | `{"fsGroup":999,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":999,"runAsNonRoot":true,"runAsUser":999}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| service | object | `{"ipFamilies":["IPv4"],"port":5432,"type":"ClusterIP"}` | Service parameters ref: https://kubernetes.io/docs/user-guide/services/ |
| service.ipFamilies | list | `["IPv4"]` | IP families for service possible values: IPv4, IPv6 ref: https://kubernetes.io/docs/concepts/services-networking/dual-stack/ |
| postgresqlServerMemory | string | `"128"` | Specifies the expected memory usage |
| postgresqlServerWalWriterDelay | string | `"200ms"` | Specifies how often the WAL writer flushes WAL (wal_writer_delay) ref: https://www.postgresql.org/docs/current/runtime-config-wal.html |
| resources | object | `{"requests":{"cpu":"100m","memory":"128Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"enabled":false,"mountPath":"/database","size":"8Gi"}` | Persistence parameters ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| priorityClassName | string | `nil` | Priority Class Name ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass |
| terminationGracePeriodSeconds | int | `120` | The time in seconds that is allowed for a PostgreSQL instance to gracefully shutdown ref: https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks |
| updateStrategy.type | string | `"RollingUpdate"` |  |
| backup.enabled | bool | `false` |  |
| backup.recovery | bool | `false` |  |
| backup.recoveryMethod | string | `"backup"` |  |
| backup.walpush | bool | `false` |  |
| backup.walg | object | `{}` |  |
| backup.walgSourceConfig | string | `nil` |  |
| backup.walgSecrets | string | `nil` |  |
| backup.cleanPolicy | string | `"retain FULL 3"` |  |
| backup.schedule | string | `"15 4 * * *"` | Backup schedule. set value "" to disable cron backup refs: https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/ |
| backup.resources | object | `{"limits":{"cpu":2,"memory":"2Gi"},"requests":{"cpu":"1500m","memory":"768Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| backup.priorityClassName | string | `nil` | Priority Class Name ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass |
| backup.podAffinityPreset | string | `"hard"` |  |
| backupCheck.enabled | bool | `false` |  |
| backupCheck.schedule | string | `"15 8 * * *"` |  |
| backupCheck.resources | object | `{"limits":{"cpu":2,"memory":"1Gi"},"requests":{"cpu":"100m","memory":"512Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| backupCheck.persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"size":"8Gi"}` | Persistence parameters ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| backupCheck.nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| backupCheck.tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| backupCheck.affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| metrics.enabled | bool | `false` |  |
| metrics.image.repository | string | `"quay.io/prometheuscommunity/postgres-exporter"` |  |
| metrics.image.pullPolicy | string | `"IfNotPresent"` |  |
| metrics.image.tag | string | `"v0.11.1"` |  |
| metrics.database | string | `"postgres"` |  |
| metrics.username | string | `"postgres"` |  |
| metrics.slowQueries | bool | `true` |  |
| metrics.queries | string | `"{{- if eq .Values.installationType \"standalone\" }}\npg_replication:\n  query: SELECT CASE WHEN NOT pg_is_in_recovery() THEN 0 ELSE GREATEST (0, EXTRACT(EPOCH FROM (now() - pg_last_xact_replay_timestamp()))) END AS lag\n  metrics:\n    - lag:\n        usage: \"GAUGE\"\n        description: \"Replication lag behind master in seconds\"\npg_postmaster:\n  query: SELECT pg_postmaster_start_time as start_time_seconds from pg_postmaster_start_time()\n  metrics:\n    - start_time_seconds:\n        usage: \"GAUGE\"\n        description: \"Time at which postmaster started\"\n{{- end }}\n{{- if and .Values.metrics.slowQueries (regexMatch \"^[0-9]+\\\\.[0-9]+$\" .Values.image.tag) (semverCompare \">=14.0\" (default .Chart.AppVersion .Values.image.tag)) }}\npg_stat_slow_queries:\n  query: SELECT pg_get_userbyid(userid) as rolname,t3.datname,queryid,calls,max_exec_time / 1000 as max_time_seconds,REGEXP_REPLACE(substring(query,1,200),'[\"\\n\\s\\t]+',' ','g') as sql FROM pg_stat_statements t1 JOIN pg_database t3 ON (t1.dbid=t3.oid) WHERE datname != 'postgres' AND rows != 0 AND max_exec_time > 1000 ORDER BY max_exec_time DESC LIMIT 10\n  metrics:\n    - rolname:\n        usage: \"LABEL\"\n        description: \"Name of user\"\n    - datname:\n        usage: \"LABEL\"\n        description: \"Name of database\"\n    - queryid:\n        usage: \"LABEL\"\n        description: \"Query ID\"\n    - sql:\n        usage: \"LABEL\"\n        description: \"SQL\"\n    - calls:\n        usage: \"COUNTER\"\n        description: \"Number of times executed\"\n    - max_time_seconds:\n        usage: \"GAUGE\"\n        description: \"Maximum time spent in the statement, in milliseconds\"\npg_stat_statements:\n  query: |\n    SELECT pg_get_userbyid(userid) as user, pg_database.datname, pg_stat_statements.queryid, REGEXP_REPLACE(substring(pg_stat_statements.query,1,200),'[\"\\n\\s\\t]+',' ','g') as query,\n           pg_stat_statements.calls, pg_stat_statements.total_exec_time as time_milliseconds, pg_stat_statements.rows,\n           pg_stat_statements.shared_blks_hit, pg_stat_statements.shared_blks_read, pg_stat_statements.shared_blks_dirtied,\n           pg_stat_statements.shared_blks_written, pg_stat_statements.local_blks_hit, pg_stat_statements.local_blks_read,\n           pg_stat_statements.local_blks_dirtied, pg_stat_statements.local_blks_written, pg_stat_statements.temp_blks_read,\n           pg_stat_statements.temp_blks_written, pg_stat_statements.blk_read_time, pg_stat_statements.blk_write_time\n           FROM pg_stat_statements JOIN pg_database ON pg_database.oid = pg_stat_statements.dbid AND max_exec_time > 10\n           WHERE pg_stat_statements.query not like '%pg_stat_statements%' and pg_database.datname != 'postgres'\n           and pg_stat_statements.query not like 'SET %' and pg_stat_statements.query != 'COMMIT' and pg_stat_statements.query != 'BEGIN'\n           and pg_stat_statements.query not like '%SAVEPOINT%'\n           ORDER BY pg_stat_statements.total_exec_time DESC LIMIT 100\n  metrics:\n    - user:\n        usage: \"LABEL\"\n        description: \"The user who executed the statement\"\n    - datname:\n        usage: \"LABEL\"\n        description: \"The database in which the statement was executed\"\n    - queryid:\n        usage: \"LABEL\"\n        description: \"Internal hash code, computed from the statement's parse tree\"\n    - query:\n        usage: \"LABEL\"\n        description: \"Processed query\"\n    - calls:\n        usage: \"COUNTER\"\n        description: \"Number of times executed\"\n    - time_milliseconds:\n        usage: \"COUNTER\"\n        description: \"Total time spent in the statement, in milliseconds\"\n    - rows:\n        usage: \"COUNTER\"\n        description: \"Total number of rows retrieved or affected by the statement\"\n    - shared_blks_hit:\n        usage: \"COUNTER\"\n        description: \"Total number of shared block cache hits by the statement\"\n    - shared_blks_read:\n        usage: \"COUNTER\"\n        description: \"Total number of shared blocks read by the statement\"\n    - shared_blks_dirtied:\n        usage: \"COUNTER\"\n        description: \"Total number of shared blocks dirtied by the statement\"\n    - shared_blks_written:\n        usage: \"COUNTER\"\n        description: \"Total number of shared blocks written by the statement\"\n    - local_blks_hit:\n        usage: \"COUNTER\"\n        description: \"Total number of local block cache hits by the statement\"\n{{- end }}\npg_stat_activity_idle:\n  query: |\n    WITH\n      metrics AS (\n        SELECT\n          application_name,\n          SUM(EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - state_change))::bigint)::float AS process_seconds_sum,\n          COUNT(*) AS process_seconds_count\n        FROM pg_stat_activity\n        WHERE state = 'idle'\n        GROUP BY application_name\n      ),\n      buckets AS (\n        SELECT\n          application_name,\n          le,\n          SUM(\n            CASE WHEN EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - state_change)) <= le\n              THEN 1\n              ELSE 0\n            END\n          )::bigint AS bucket\n        FROM\n          pg_stat_activity,\n          UNNEST(ARRAY[1, 2, 5, 15, 30, 60, 90, 120, 300]) AS le\n        GROUP BY application_name, le\n        ORDER BY application_name, le\n      )\n    SELECT\n      application_name,\n      process_seconds_sum,\n      process_seconds_count,\n      ARRAY_AGG(le) AS process_seconds,\n      ARRAY_AGG(bucket) AS process_seconds_bucket\n    FROM metrics JOIN buckets USING (application_name)\n    GROUP BY 1, 2, 3\n  metrics:\n    - application_name:\n        usage: \"LABEL\"\n        description: \"Application Name\"\n    - process_seconds:\n        usage: \"HISTOGRAM\"\n        description: \"Idle time of server processes\""` |  |
| metrics.resources | object | `{"limits":{"cpu":"200m","memory":"128Mi"},"requests":{"cpu":"10m","memory":"32Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| podDisruptionBudget.create | bool | `true` |  |
| podDisruptionBudget.minAvailable | int | `1` |  |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| podAntiAffinityPreset | string | `"hard"` | Pod Anti Affinity soft/hard |
| podAntiAffinityPresetKey | string | `"kubernetes.io/hostname"` |  |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
