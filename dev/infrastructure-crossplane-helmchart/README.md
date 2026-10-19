# infrastructure-helmchart

Deploys infrastructure objects supplied through values. This intentionally
does not hardcode Crossplane provider APIs: the infrastructure repository can
provide Crossplane claims, managed resources, compositions, functions,
provider configs, or ordinary Kubernetes support resources in the `resources`
list.

Example:

```yaml
resources:
  - apiVersion: rds.aws.upbound.io/v1beta1
    kind: Instance
    metadata:
      name: application-database
    spec:
      forProvider:
        region: eu-west-1
```
