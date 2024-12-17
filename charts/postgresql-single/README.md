# postgresql-single

![Version: 1.0.2](https://img.shields.io/badge/Version-1.0.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 16.6](https://img.shields.io/badge/AppVersion-16.6-informational?style=flat-square)

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
pgHbaConfiguration: |-
  local   all         all                                 trust
  local   replication postgres                            trust
  host    all         all                   localhost     md5
  hostssl postgres    postgres              10.0.0.0/8    md5
  hostssl postgres    replication           10.0.0.0/8    md5
  hostssl replication postgres              10.0.0.0/8    md5
  hostssl replication replication           10.0.0.0/8    md5

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
| command | list | `[]` | command Override default container command |
| env | list | `[]` |  |
| postgresqlUsername | string | `"postgres"` | PostgreSQL admin user ref: https://hub.docker.com/_/postgres |
| postgresqlMaxConnections | int | `150` | Create a database ref: https://hub.docker.com/_/postgres postgresqlDatabase: |
| pgHbaConfiguration | string | `"# host  database    user                  address       auth-method\n#\nlocal   all         all                                 trust\nlocal   replication postgres                            trust\nhost    all         all                   localhost     md5\nhostssl all         postgres              10.0.0.0/8    md5\nhostssl postgres    postgres              10.0.0.0/8    md5\nhost    replication postgres              10.0.0.0/8    md5\nhostssl replication postgres              10.0.0.0/8    md5"` | Postgres auth ref: https://www.postgresql.org/docs/current/auth-pg-hba-conf.html |
| initdb.args | string | `"--data-checksums --auth-host=scram-sha-256"` |  |
| initdb.script | string | `""` |  |
| tlsCerts.create | bool | `false` |  |
| tlsCerts.mode | string | `"require"` |  |
| initContainers | list | `[]` |  |
| serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | Pods Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| podlabels | object | `{}` | Extra labels for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podSecurityContext | object | `{"fsGroup":999,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":999,"runAsNonRoot":true,"runAsUser":999}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| service | object | `{"ipFamilies":["IPv4"],"port":5432,"type":"ClusterIP"}` | Service parameters ref: https://kubernetes.io/docs/user-guide/services/ |
| postgresqlServerMemory | string | `"128"` |  |
| resources | object | `{"requests":{"cpu":"100m","memory":"128Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"enabled":false,"mountPath":"/database","size":"8Gi"}` | Persistence parameters ref: https://kubernetes.io/docs/user-guide/persistent-volumes/ |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.maxReplicas | int | `3` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| priorityClassName | string | `nil` | Priority Class Name ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass |
| terminationGracePeriodSeconds | int | `120` |  |
| updateStrategy.type | string | `"RollingUpdate"` |  |
| backup.enabled | bool | `false` |  |
| backup.recovery | bool | `false` |  |
| backup.walpush | bool | `false` |  |
| backup.walg | object | `{}` |  |
| backup.cleanPolicy | string | `"retain FULL 3"` |  |
| backup.schedule | string | `"15 4 * * *"` |  |
| backup.resources | object | `{"limits":{"cpu":2,"memory":"1Gi"},"requests":{"cpu":"1500m","memory":"768Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
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
| metrics.queries | string | `"pg_replication:\n  query: \"SELECT CASE WHEN NOT pg_is_in_recovery() THEN 0 ELSE GREATEST (0, EXTRACT(EPOCH FROM (now() - pg_last_xact_replay_timestamp()))) END AS lag\"\n  master: true\n  metrics:\n    - lag:\n        usage: \"GAUGE\"\n        description: \"Replication lag behind master in seconds\"\npg_postmaster:\n  query: \"SELECT pg_postmaster_start_time as start_time_seconds from pg_postmaster_start_time()\"\n  master: true\n  metrics:\n    - start_time_seconds:\n        usage: \"GAUGE\"\n        description: \"Time at which postmaster started\"\n{{- if and (regexMatch \"^[0-9]+\\\\.[0-9]+$\" .Values.image.tag) (semverCompare \">=14.0\" (default .Chart.AppVersion .Values.image.tag)) }}\npg_stat_slow_queries:\n  query: SELECT pg_get_userbyid(userid) as rolname,t3.datname,queryid,calls,max_exec_time / 1000 as max_time_seconds,REGEXP_REPLACE(substring(query,1,100),'[\"\\n\\s\\t]','','g') as sql FROM pg_stat_statements t1 JOIN pg_database t3 ON (t1.dbid=t3.oid) WHERE datname != 'postgres' AND rows != 0 AND max_exec_time > 1000 ORDER BY max_exec_time DESC LIMIT 10\n  metrics:\n    - rolname:\n        usage: \"LABEL\"\n        description: \"Name of user\"\n    - datname:\n        usage: \"LABEL\"\n        description: \"Name of database\"\n    - queryid:\n        usage: \"LABEL\"\n        description: \"Query ID\"\n    - sql:\n        usage: \"LABEL\"\n        description: \"SQL\"\n    - calls:\n        usage: \"COUNTER\"\n        description: \"Number of times executed\"\n    - max_time_seconds:\n        usage: \"GAUGE\"\n        description: \"Maximum time spent in the statement, in milliseconds\"\npg_stat_statements:\n  query: \"SELECT pg_get_userbyid(userid) as user, pg_database.datname, pg_stat_statements.queryid, REGEXP_REPLACE(substring(pg_stat_statements.query,1,100),'[\"\\n\\s\\t]','','g') as query,\n           pg_stat_statements.calls, pg_stat_statements.total_exec_time as time_milliseconds, pg_stat_statements.rows,\n           pg_stat_statements.shared_blks_hit, pg_stat_statements.shared_blks_read, pg_stat_statements.shared_blks_dirtied,\n           pg_stat_statements.shared_blks_written, pg_stat_statements.local_blks_hit, pg_stat_statements.local_blks_read,\n           pg_stat_statements.local_blks_dirtied, pg_stat_statements.local_blks_written, pg_stat_statements.temp_blks_read,\n           pg_stat_statements.temp_blks_written, pg_stat_statements.blk_read_time, pg_stat_statements.blk_write_time\n           FROM pg_stat_statements JOIN pg_database ON pg_database.oid = pg_stat_statements.dbid\n           ORDER BY pg_stat_statements.total_exec_time DESC LIMIT 100\"\n  metrics:\n    - user:\n        usage: \"LABEL\"\n        description: \"The user who executed the statement\"\n    - datname:\n        usage: \"LABEL\"\n        description: \"The database in which the statement was executed\"\n    - queryid:\n        usage: \"LABEL\"\n        description: \"Internal hash code, computed from the statement's parse tree\"\n    - query:\n        usage: \"LABEL\"\n        description: \"Processed query\"\n    - calls:\n        usage: \"COUNTER\"\n        description: \"Number of times executed\"\n    - time_milliseconds:\n        usage: \"COUNTER\"\n        description: \"Total time spent in the statement, in milliseconds\"\n    - rows:\n        usage: \"COUNTER\"\n        description: \"Total number of rows retrieved or affected by the statement\"\n    - shared_blks_hit:\n        usage: \"COUNTER\"\n        description: \"Total number of shared block cache hits by the statement\"\n    - shared_blks_read:\n        usage: \"COUNTER\"\n        description: \"Total number of shared blocks read by the statement\"\n    - shared_blks_dirtied:\n        usage: \"COUNTER\"\n        description: \"Total number of shared blocks dirtied by the statement\"\n    - shared_blks_written:\n        usage: \"COUNTER\"\n        description: \"Total number of shared blocks written by the statement\"\n    - local_blks_hit:\n        usage: \"COUNTER\"\n        description: \"Total number of local block cache hits by the statement\"\n{{- end }}\npg_stat_activity_idle:\n  query: |\n    WITH\n      metrics AS (\n        SELECT\n          application_name,\n          SUM(EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - state_change))::bigint)::float AS process_seconds_sum,\n          COUNT(*) AS process_seconds_count\n        FROM pg_stat_activity\n        WHERE state = 'idle'\n        GROUP BY application_name\n      ),\n      buckets AS (\n        SELECT\n          application_name,\n          le,\n          SUM(\n            CASE WHEN EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - state_change)) <= le\n              THEN 1\n              ELSE 0\n            END\n          )::bigint AS bucket\n        FROM\n          pg_stat_activity,\n          UNNEST(ARRAY[1, 2, 5, 15, 30, 60, 90, 120, 300]) AS le\n        GROUP BY application_name, le\n        ORDER BY application_name, le\n      )\n    SELECT\n      application_name,\n      process_seconds_sum,\n      process_seconds_count,\n      ARRAY_AGG(le) AS process_seconds,\n      ARRAY_AGG(bucket) AS process_seconds_bucket\n    FROM metrics JOIN buckets USING (application_name)\n    GROUP BY 1, 2, 3\n  metrics:\n    - application_name:\n        usage: \"LABEL\"\n        description: \"Application Name\"\n    - process_seconds:\n        usage: \"HISTOGRAM\"\n        description: \"Idle time of server processes\""` |  |
| metrics.resources | object | `{"limits":{"cpu":"200m","memory":"128Mi"},"requests":{"cpu":"10m","memory":"32Mi"}}` | Resource requests and limits. ref: https://kubernetes.io/docs/user-guide/compute-resources/ |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
