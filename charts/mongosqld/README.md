# Mongosqld

MongoDB Connector for BI

```yaml
# helm values

config: |
  mongodb:
    net:
      uri: "mongodb://mongo-hidden-headless:27017/?connect=direct"
      auth:
        username: username
        password: password

  schema:
    maxVarcharLength: 8000
    refreshIntervalSecs: 3600
    stored:
      mode: "custom" # "auto"
      source: "mongoSchema"
```
