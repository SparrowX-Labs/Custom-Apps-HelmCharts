# application-helmchart

Reusable application workload chart. Application repositories provide a
values file and select the resources they need through `service`, `ingress`,
`configMap`, `secret`, and `autoscaling` values.

The image repository and tag are optional Helm inputs supplied by the deploying
Argo CD workflow or Image Updater. When provided, they render as
`repository:tag`. Secret `data` values must already be
base64-encoded; use `stringData` for plaintext values supplied through a
secret-management workflow.

When `database.enabled` is true, the chart discovers the RDS-managed
Secrets Manager secret using the derived `Name`, `Project`, `Environment`, and
RDS ownership tags. It creates a Kubernetes Secret through External Secrets
Operator and automatically exposes it to the Deployment with `envFrom`.
Application-specific values only need to provide the database name:

```yaml
database:
  enabled: true
  name: customerdb
  engine: postgres
  port: 5432
  host: customerdb.example.internal
```

When enabled, the chart exposes these non-sensitive values as `DB_ENGINE`,
`DB_HOST`, `DB_PORT`, and `DB_NAME`. The ExternalSecret maps the RDS-managed
`username` and `password` fields to `DB_USERNAME` and `DB_PASSWORD`.

Resource sizing is selected with one value. The chart translates the size to
CPU and memory requests and limits:

```yaml
resources:
  size: medium
```

Supported sizes are `micro`, `small`, `medium`, `large`, and `xlarge`.

Database access is disabled unless `database.enabled` is the boolean `true`.
It can therefore be omitted for applications without a database.

Health probes are enabled only when their values block contains
`enabled: true`. The default timing values are defined in the chart under
`probeDefaults`. Applications can provide a shared health-check path and
override only the probe settings they need:

```yaml
probePath: /health

readinessProbe:
  enabled: true
  failureThreshold: 5
```

The other probe fields use chart defaults. If a probe block is omitted, or
`enabled` is not exactly the boolean `true`, that probe is disabled.

ConfigMaps can be defined in the application values repository under the
`configMap` section. The chart renders the resulting ConfigMap beside the
Deployment; the application can consume it through `container.envFrom` or
`container.env` using a `configMapRef` or `configMapKeyRef`.
