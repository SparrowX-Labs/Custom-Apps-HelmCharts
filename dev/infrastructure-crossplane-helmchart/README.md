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

The RDS provider generates the password and publishes a Kubernetes connection
Secret. When `database.secretsManager.enabled` is true, the generated password
is also written to the AWS Secrets Manager secret named
`<projectName>/<database.name>/creds`. The username remains the configured
`database.username` value (`postgres_admin` by default).

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
