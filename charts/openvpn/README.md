# OpenVPN on kubernetes

## Deploy openvpn with users

Cert manager creates a tls secrets and store in kubernetes secretes.
`clientConfigRBAC` sets RBAC policy, it allow to download openvpn config/secrets by users.

```yaml
# helm values
certManager:
  createCerts: true

  clientConfigRBAC: true
  clients:
    - user-1@example.com
    - user-2@example.com

openvpn:
  hostName: vpn.example.com

  config: |
    server 172.30.1.0 255.255.255.0
    topology p2p
    data-ciphers AES-256-GCM:AES-128-GCM
    data-ciphers-fallback AES-256-CBC

  defaultroutes: |
    push "dhcp-option DNS 172.30.1.1"
    push "route 1.1.1.1"
    push "route 8.8.8.8"
```

## Deploy openvpn with users and OTP

As previous example, we will create a tls certs and user configs.
Additionally, we will use OTP (one time password) to login on openvpn.

To create OTP key: `docker run --rm -ti --entrypoint=google-authenticator ghcr.io/sergelogvinov/openvpn:2.5.8-2 -tdfW -r 3 -R 60`

```yaml
# helm values
certManager:
  createCerts: true

  clientConfigRBAC: true
  clients:
    - user-1@example.com
    - user-2@example.com

openvpn:
  hostName: vpn.example.com
  # google-authenticator -tdfW -r 3 -R 60
  otp: PMTYASQTPLU6OKR2

  config: |
    server 172.30.1.0 255.255.255.0
    topology p2p
    data-ciphers AES-256-GCM:AES-128-GCM
    data-ciphers-fallback AES-256-CBC

  defaultroutes: |
    push "dhcp-option DNS 172.30.1.1"
    push "route 1.1.1.1"
    push "route 8.8.8.8"
```
