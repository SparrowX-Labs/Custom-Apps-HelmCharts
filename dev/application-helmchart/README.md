# application-helmchart

Reusable application workload chart. Application repositories provide a
values file and select the resources they need through `service`, `ingress`,
`configMap`, `secret`, and `autoscaling` values.

The image repository is required. Secret `data` values must already be
base64-encoded; use `stringData` for plaintext values supplied through a
secret-management workflow.
