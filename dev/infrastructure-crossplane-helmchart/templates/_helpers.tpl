{{- define "infrastructure-helmchart.databaseName" -}}
{{- $name := required "database.name is required when database.enabled is true" .Values.database.name }}
{{- printf "%s-%s-%s" .Values.projectName .Values.environment $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "infrastructure-helmchart.databaseSecurityGroupName" -}}
{{- printf "%s-sg" (include "infrastructure-helmchart.databaseName" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "infrastructure-helmchart.databaseSubnetGroupName" -}}
{{- printf "%s-subnet-group" (include "infrastructure-helmchart.databaseName" .) | trunc 255 | trimSuffix "-" }}
{{- end }}

{{- define "infrastructure-helmchart.connectionSecretName" -}}
{{- printf "%s-connection" (include "infrastructure-helmchart.databaseName" .) | trunc 253 | trimSuffix "-" }}
{{- end }}
