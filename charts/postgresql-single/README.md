# postgresql-single

![Version: 0.5.3](https://img.shields.io/badge/Version-0.5.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 14.8](https://img.shields.io/badge/AppVersion-14.8-informational?style=flat-square)

Postgres with backup/restore checks

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/master/charts/postgresql-single>

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
  walpush: true  # Send wal for the s3.

  walg: |
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
| postgresqlUsername | string | `"postgres"` | PostgreSQL admin user ref: https://hub.docker.com/_/postgres |
| pgHbaConfiguration | string | `"# host  database    user                  address       auth-method\n#\nlocal   all         all                                 trust\nlocal   replication postgres                            trust\nhost    all         all                   localhost     trust\nhost    postgres    postgres              10.0.0.0/8    md5\nhostssl postgres    postgres              10.0.0.0/8    md5\nhost    replication postgres              10.0.0.0/8    md5\nhostssl replication postgres              10.0.0.0/8    md5"` | PostgreSQL connection string postgresqlConninfo: host=postgres user=postgres |
| tlsCerts.create | bool | `false` |  |
| serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | Pods Service Account. ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| podlabels | object | `{}` | Extra labels for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podAnnotations | object | `{}` | Annotations for pod. ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podSecurityContext | object | `{"fsGroup":999,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":999,"runAsNonRoot":true,"runAsUser":999}` | Pod Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod |
| service | object | `{"port":5432,"type":"ClusterIP"}` | Service parameters ref: https://kubernetes.io/docs/user-guide/services/ |
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
| backup.walg | string | `nil` |  |
| backup.cleanPolicy | string | `"retain FULL 3"` |  |
| backup.schedule | string | `"15 4 * * *"` |  |
| backup.resources.limits.cpu | int | `2` |  |
| backup.resources.limits.memory | string | `"1Gi"` |  |
| backup.resources.requests.cpu | string | `"1500m"` |  |
| backup.resources.requests.memory | string | `"512Mi"` |  |
| backup.podAffinityPreset | string | `"hard"` |  |
| backupCheck.enabled | bool | `false` |  |
| backupCheck.schedule | string | `"15 8 * * *"` |  |
| backupCheck.resources.limits.cpu | int | `2` |  |
| backupCheck.resources.limits.memory | string | `"1Gi"` |  |
| backupCheck.resources.requests.cpu | string | `"100m"` |  |
| backupCheck.resources.requests.memory | string | `"512Mi"` |  |
| backupCheck.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| backupCheck.persistence.size | string | `"8Gi"` |  |
| backupCheck.persistence.annotations | object | `{}` |  |
| backupCheck.nodeSelector | object | `{}` |  |
| backupCheck.tolerations | list | `[]` |  |
| backupCheck.affinity | object | `{}` |  |
| metrics.enabled | bool | `false` |  |
| metrics.image.repository | string | `"quay.io/prometheuscommunity/postgres-exporter"` |  |
| metrics.image.pullPolicy | string | `"IfNotPresent"` |  |
| metrics.image.tag | string | `"v0.11.1"` |  |
| metrics.database | string | `"postgres"` |  |
| metrics.username | string | `"postgres"` |  |
| metrics.queries | string | `"pg_replication:\n  query: \"SELECT CASE WHEN NOT pg_is_in_recovery() THEN 0 ELSE GREATEST (0, EXTRACT(EPOCH FROM (now() - pg_last_xact_replay_timestamp()))) END AS lag\"\n  master: true\n  metrics:\n    - lag:\n        usage: \"GAUGE\"\n        description: \"Replication lag behind master in seconds\"\npg_postmaster:\n  query: \"SELECT pg_postmaster_start_time as start_time_seconds from pg_postmaster_start_time()\"\n  master: true\n  metrics:\n    - start_time_seconds:\n        usage: \"GAUGE\"\n        description: \"Time at which postmaster started\"\n{{- if semverCompare \">=14.0\" (.Values.image.tag | default .Chart.AppVersion) }}\npg_stat_slow_queries:\n  query: SELECT pg_get_userbyid(userid) as rolname,t3.datname,queryid,calls,max_exec_time / 1000 as max_time_seconds,REGEXP_REPLACE(substring(query,1,100),'[\"\\n\\s]','','g') as sql FROM pg_stat_statements t1 JOIN pg_database t3 ON (t1.dbid=t3.oid) WHERE rows != 0 AND max_exec_time > 1000 ORDER BY max_exec_time DESC LIMIT 10\n  metrics:\n    - rolname:\n        usage: \"LABEL\"\n        description: \"Name of user\"\n    - datname:\n        usage: \"LABEL\"\n        description: \"Name of database\"\n    - queryid:\n        usage: \"LABEL\"\n        description: \"Query ID\"\n    - sql:\n        usage: \"LABEL\"\n        description: \"SQL\"\n    - calls:\n        usage: \"COUNTER\"\n        description: \"Number of times executed\"\n    - max_time_seconds:\n        usage: \"GAUGE\"\n        description: \"Maximum time spent in the statement, in milliseconds\"\n{{- end }}\npg_stat_activity_idle:\n  query: |\n    WITH\n      metrics AS (\n        SELECT\n          application_name,\n          SUM(EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - state_change))::bigint)::float AS process_seconds_sum,\n          COUNT(*) AS process_seconds_count\n        FROM pg_stat_activity\n        WHERE state = 'idle'\n        GROUP BY application_name\n      ),\n      buckets AS (\n        SELECT\n          application_name,\n          le,\n          SUM(\n            CASE WHEN EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - state_change)) <= le\n              THEN 1\n              ELSE 0\n            END\n          )::bigint AS bucket\n        FROM\n          pg_stat_activity,\n          UNNEST(ARRAY[1, 2, 5, 15, 30, 60, 90, 120, 300]) AS le\n        GROUP BY application_name, le\n        ORDER BY application_name, le\n      )\n    SELECT\n      application_name,\n      process_seconds_sum,\n      process_seconds_count,\n      ARRAY_AGG(le) AS process_seconds,\n      ARRAY_AGG(bucket) AS process_seconds_bucket\n    FROM metrics JOIN buckets USING (application_name)\n    GROUP BY 1, 2, 3\n  metrics:\n    - application_name:\n        usage: \"LABEL\"\n        description: \"Application Name\"\n    - process_seconds:\n        usage: \"HISTOGRAM\"\n        description: \"Idle time of server processes\""` |  |
| metrics.resources.limits.cpu | string | `"200m"` |  |
| metrics.resources.limits.memory | string | `"128Mi"` |  |
| metrics.resources.requests.cpu | string | `"10m"` |  |
| metrics.resources.requests.memory | string | `"32Mi"` |  |
| nodeSelector | object | `{}` | Node labels for pod assignment. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| tolerations | list | `[]` | Tolerations for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| affinity | object | `{}` | Affinity for pod assignment. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
