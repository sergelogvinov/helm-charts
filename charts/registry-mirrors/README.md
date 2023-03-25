# Registry mirrors on kubernetes

```yaml
auth:
  tls: true

# Registry by default:
mirrors:
  - host: docker.io
    source: https://registry-1.docker.io
  - host: gcr.io
    source: https://gcr.io
  - host: ghcr.io
    source: https://ghcr.io

ingress:
  enabled: true
  hosts:
    - host: mirrors.example.com
      path: /
```

## Talos machine config

```yaml
machine:
  registries:
    config:
      mirrors.example.com:
        tls:
          clientIdentity:
            crt: BASE64-crt
            key: BASE64-key
    mirrors:
      docker.io:
        endpoints:
          - https://mirrors.example.com/docker-io
      gcr.io:
        endpoints:
          - https://mirrors.example.com/gcr-io
      ghcr.io:
        endpoints:
          - https://mirrors.example.com/ghcr-io
```
