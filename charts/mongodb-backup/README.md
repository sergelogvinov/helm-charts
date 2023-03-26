# Mongodb logical backup

* Support backup/restore to the extrernal storage, using [wal-g](https://github.com/wal-g)
* Daily backup check by restoring process

```yaml
# helm values

auth:
  host: mongo-0.mongo-headless:27017/?authSource=admin

walg: |
  WALG_S3_PREFIX: s3://backup/mongo-backup

extraVolumes:
  - name: s3-secrets
    secret:
      defaultMode: 256
      secretName: backup-s3
extraVolumeMounts:
  - name: s3-secrets
    mountPath: /var/backups/.aws
    readOnly: true

backupCheck:
  enabled: true
```
