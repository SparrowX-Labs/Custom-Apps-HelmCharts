# Custom Apps Helm Charts

Reusable charts consumed by Argo CD applications.

## Chart ownership

| Chart | Values should live in | Purpose |
| --- | --- | --- |
| `application-helmchart` | Each application repository | Deploy one application workload and its optional Service, Ingress, ConfigMap, Secret, and HPA |
| `gateway-api-helmchart` | The Gateway API repository | Deploy one gateway application containing any number of Gateway API objects |
| `infrastructure-helmchart` | The Crossplane/infrastructure repository | Deploy Crossplane claims, managed resources, compositions, provider configs, and supporting Kubernetes resources |

## Gateway API layout

Gateway API should be one Argo CD application with one values file. The values
file can contain multiple `gateways`, `httpRoutes`, `grpcRoutes`, and other
resources. Keep the Gateway API CRDs and AWS Load Balancer Controller in the
platform repository; this chart only manages the Gateway API objects owned by
the gateway application.

## Argo CD values from another repository

When the chart and values are in different repositories, use Argo CD multiple
sources. The values source is referenced with `$values`:

```yaml
spec:
  sources:
    - repoURL: https://github.com/SparrowX-Labs/Custom-Apps-HelmCharts.git
      targetRevision: main
      path: application-helmchart
      helm:
        valueFiles:
          - $values/dev/values.yaml
    - repoURL: https://github.com/SparrowX-Labs/example-application.git
      targetRevision: main
      ref: values
```

For the Gateway API and infrastructure applications, replace the chart path
and values repository with `gateway-api-helmchart` plus the Gateway API repo,
or `infrastructure-helmchart` plus the Crossplane repo.
