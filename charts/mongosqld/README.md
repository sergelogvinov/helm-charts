# Mongosqld

MongoDB Connector for BI

## Create user

```shell
db.createUser({user: 'mongosql', pwd:"mongosql", roles: [{ 'role': 'read', 'db': 'db' }] })
db.createUser({user: 'mongosql', pwd:"mongosql", roles: [{ 'role': 'readWrite', 'db': 'dbSchema' }] })
```

## Deploy chart

```yaml
# helm values

auth:
  host: mongo-rs0:27017
  username: mongosql
  password: mongosql
  database: db
```
