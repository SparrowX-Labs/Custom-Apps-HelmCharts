# infrastructure-helmchart

Deploys modular infrastructure objects through values. Database and S3
resources are enabled independently, while additional Crossplane or
Kubernetes objects can be supplied through the `resources` list.

The shared values are defined once at the root:

```yaml
environment: dev
projectName: sparrowx
region: eu-west-1
vpcId: vpc-0123456789abcdef0
privateSubnetIds:
  - subnet-0123456789abcdef0
  - subnet-0123456789abcdef1
  - subnet-0123456789abcdef2
```

Enable a PostgreSQL database with a small set of database-specific values:

```yaml
database:
  enabled: true
  type: postgres
  name: customerdb
  instanceClass: db.t4g.micro
  allocatedStorage: 20
  backupRetentionPeriod: 1
  multiAZ: false
```

RDS manages the master password in AWS Secrets Manager, avoiding a password
Secret that must be created in Kubernetes before the database exists. The RDS
connection Secret contains the connection details published by Crossplane.
When `database.secretsManager.enabled` is true, the chart creates the
AWS Secrets Manager secret metadata. To create a version, set
`database.secretsManager.passwordSourceSecretName` to a populated Kubernetes
Secret and set its key with `passwordSourceSecretKey`. This is intentionally
separate because the RDS connection Secret is empty until the database is
ready.

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
