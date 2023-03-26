# Fluentd

Launch fluentd as log router.

This chart uses with fluent-bit chart.
Fluent-bit is gathering the logs, and sending to fluentd deploy (fluentd router).
When fluentd routes the traffic to different destinations.

```yaml
# helm values

annotations:
  fluentbit.io/exclude: "true"
  prometheus.io/scrape: "true"
  prometheus.io/port: "24231"

useDaemonSet: true

env:
  FLUENTD_CONF: /fluentd/etc/fluent.conf

configMaps:
  output.conf: |
    <match **>
      @type stdout
      <format>
        @type hash
      </format>
    </match>

metrics:
  enabled: true

nodeSelector:
  node-role.kubernetes.io/control-plane: ""
tolerations:
  - key: node-role.kubernetes.io/control-plane
    effect: NoSchedule
```
