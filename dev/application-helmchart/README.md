# application-helmchart

Reusable application workload chart. Application repositories provide a
values file and select the resources they need through `service`, `ingress`,
`configMap`, `secret`, and `autoscaling` values.

The image repository is required. Secret `data` values must already be
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
`DB_HOST`, and `DB_PORT`. Credentials remain supplied separately through the
configured secret integration.
