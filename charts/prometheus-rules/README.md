# prometheus-rules

![Version: 0.2.16](https://img.shields.io/badge/Version-0.2.16-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.40.0](https://img.shields.io/badge/AppVersion-2.40.0-informational?style=flat-square)

Static prometheus/victoria metrics common rules

Helm chart containing Prometheus/VictoriaMetrics basic kubernetes rules.
It's stores as configMap and mounted to Prometheus/VictoriaMetrics pods.

**Homepage:** <https://github.com/sergelogvinov/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sergelogvinov |  | <https://github.com/sergelogvinov> |

## Source Code

* <https://github.com/sergelogvinov/helm-charts/tree/main/charts/prometheus-rules>

Static configmap.

Base on projects:
* [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts)
* [prometheus-operator](https://github.com/prometheus-operator/kube-prometheus/tree/main/manifests)
* https://github.com/roaldnefs/awesome-prometheus

### Prometheus setup

helm upgrade -i -n monitoring -f prometheus-rules.yaml prometheus-rules oci://ghcr.io/sergelogvinov/charts/prometheus-rules

```yaml
# prometheus-rules.yaml

prometheusConfig:
  enabled: true

  ruleFiles:
    - /etc/prometheus-rules/*.yml
```

helm upgrade -i -n monitoring -f prometheus.yaml prometheus prometheus-community/prometheus

```yaml
# prometheus.yaml

server:
  podAnnotations:
    prometheus.io/scrape: 'true'
    prometheus.io/port: '9090'

  configMapOverrideName: rules-config
  extraConfigmapMounts:
    - name: rules-configmap
      mountPath: /etc/prometheus-rules
      configMap: prometheus-rules
      readOnly: true
  extraSecretMounts:
    - name: scrape
      mountPath: /etc/secrets/scrape
      secretName: prometheus-rules-scrape
      readOnly: true

configmapReload:
  prometheus:
    extraVolumeDirs:
      - /etc/prometheus-rules
    extraConfigmapMounts:
      - name: rules-configmap
        mountPath: /etc/prometheus-rules
        configMap: prometheus-rules
        readOnly: true
```

### VictoriaMetrics setup

helm upgrade -i -n monitoring -f prometheus-rules.yaml prometheus-rules oci://ghcr.io/sergelogvinov/charts/prometheus-rules

```yaml
# prometheus-rules.yaml

victoriaMetricsConfig:
  enabled: true

  ruleFiles:
    - /etc/prometheus-rules/*.yml
```

kubectl apply -f vm.yaml

```yaml
# vm.yaml
apiVersion: operator.victoriametrics.com/v1beta1
kind: VMAlert
spec:
  podMetadata:
    annotations:
      prometheus.io/scrape: 'true'
      prometheus.io/port: '8080'
  configMaps:
    - prometheus-rules
  rulePath:
    - /etc/vm/configs/prometheus-rules/*.yml
---
apiVersion: operator.victoriametrics.com/v1beta1
kind: VMAgent
spec:
  podMetadata:
    annotations:
      prometheus.io/scrape: 'true'
      prometheus.io/port: '8429'
  additionalScrapeConfigs:
    name: prometheus-rules-scrape
    key: scrape.yml
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| victoriaMetricsConfig.enabled | bool | `false` |  |
| victoriaMetricsConfig.global.scrape_interval | string | `"1m"` |  |
| victoriaMetricsConfig.global.scrape_timeout | string | `"10s"` |  |
| victoriaMetricsConfig.global.external_labels | object | `{}` |  |
| victoriaMetricsConfig.recordingRules | string | `nil` |  |
| victoriaMetricsConfig.extraScrapeConfigs | list | `[]` |  |
| prometheusConfig.enabled | bool | `false` |  |
| prometheusConfig.global.scrape_interval | string | `"1m"` |  |
| prometheusConfig.global.scrape_timeout | string | `"10s"` |  |
| prometheusConfig.global.evaluation_interval | string | `"1m"` |  |
| prometheusConfig.global.external_labels | object | `{}` |  |
| prometheusConfig.ruleFiles[0] | string | `"/etc/prometheus-rules/*.yml"` |  |
| prometheusConfig.remoteWrite | list | `[]` |  |
| prometheusConfig.remoteRead | list | `[]` |  |
| prometheusConfig.alertingRules | string | `nil` |  |
| prometheusConfig.recordingRules | string | `nil` |  |
| prometheusConfig.extraScrapeConfigs | list | `[]` |  |
| defaultRules.create | bool | `true` |  |
| defaultRules.runbookUrl | string | `"https://runbooks.prometheus-operator.dev/runbooks"` |  |
| defaultRules.rules.alertmanager | bool | `true` |  |
| defaultRules.rules.configReloaders | bool | `false` |  |
| defaultRules.rules.general | bool | `true` |  |
| defaultRules.rules.kubeApiserverAvailability | bool | `true` |  |
| defaultRules.rules.kubeApiserverBurnrate | bool | `true` |  |
| defaultRules.rules.kubeApiserverHistogram | bool | `true` |  |
| defaultRules.rules.kubeApiserverSlos | bool | `true` |  |
| defaultRules.rules.kubeControllerManager | bool | `true` |  |
| defaultRules.rules.kubeContainerMemory | bool | `true` |  |
| defaultRules.rules.kubelet | bool | `true` |  |
| defaultRules.rules.kubePrometheusGeneral | bool | `true` |  |
| defaultRules.rules.kubePrometheusNodeRecording | bool | `true` |  |
| defaultRules.rules.kubernetesApps | bool | `true` |  |
| defaultRules.rules.kubernetesResources | bool | `true` |  |
| defaultRules.rules.kubernetesStorage | bool | `true` |  |
| defaultRules.rules.kubernetesSystem | bool | `true` |  |
| defaultRules.rules.kubeSchedulerAlerting | bool | `true` |  |
| defaultRules.rules.kubeSchedulerRecording | bool | `true` |  |
| defaultRules.rules.kubeStateMetrics | bool | `true` |  |
| defaultRules.rules.network | bool | `true` |  |
| defaultRules.rules.node | bool | `true` |  |
| defaultRules.rules.nodeExporterAlerting | bool | `true` |  |
| defaultRules.rules.nodeExporterRecording | bool | `true` |  |
| defaultRules.rules.prometheus | bool | `true` |  |
| defaultRules.rules.prometheusOperator | bool | `false` |  |
| defaultRules.disabled.Watchdog | bool | `true` |  |
| defaultRules.disabled.InfoInhibitor | bool | `true` |  |
| defaultRules.disabled.TargetDown | bool | `true` |  |
| defaultRules.disabled.NodeDiskIOSaturation | bool | `true` |  |
| defaultRules.disabled.NodeMemoryHighUtilization | bool | `true` |  |
