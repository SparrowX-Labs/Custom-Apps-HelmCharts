# infrastructure-helmchart

Deploys modular infrastructure objects through values. Database and S3
resources are enabled independently, while additional Crossplane or
Kubernetes objects can be supplied through the `resources` list.

The shared values are defined once at the root:

```yaml
environment: dev
projectName: sparrowx
managedBy: crossplane
region: eu-west-1
vpcId: vpc-0123456789abcdef0
privateSubnetIds:
  - subnet-0123456789abcdef0
  - subnet-0123456789abcdef1
  - subnet-0123456789abcdef2
```

Managed resources use `managementPolicies: ["*"]`, so removing a resource
from the Argo CD application and syncing with prune enabled also deletes its
AWS resource. Non-empty S3 buckets still require `s3.forceDestroy: true`.

The default mode renders an `XApplicationInfrastructure` composite resource.
The XRD and Composition are installed from the Crossplane repository. Enable a
PostgreSQL database with these app-specific values:

```yaml
database:
  enabled: true
  engine: postgres
  name: customerdb
  size: small
  storage: 20
  multiAZ: false

s3:
  enabled: false
  name: customer-api-1234577095
```

`size` maps to an RDS instance class (`small` is `db.t4g.micro`; `xlarge` is
`db.t4g.large`). The
composition creates the ECR repository, database resources, and—once the RDS
endpoint is available—a Route53 CNAME such as
`customerdb-postgres.dev.sparrowx.internal`.

RDS manages the master password in AWS Secrets Manager, avoiding a custom
Secrets Manager resource that must be created before the database exists. The
chart does not create Secrets Manager resources; it only requests that RDS
manage the master password and writes the Crossplane connection Secret.

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
