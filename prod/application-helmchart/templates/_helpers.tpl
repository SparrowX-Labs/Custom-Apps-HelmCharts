{{- define "application-helmchart.name" -}}
{{- $name := default .Chart.Name .Values.serviceName -}}
{{- default $name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- define "application-helmchart.fullname" -}}
{{- default (include "application-helmchart.name" .) .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- define "application-helmchart.labels" -}}
{{- $labels := dict
      "app.kubernetes.io/name" (include "application-helmchart.name" .)
      "app.kubernetes.io/instance" .Release.Name
      "app.kubernetes.io/managed-by" .Release.Service
      "app.kubernetes.io/part-of" .Values.projectName
      "helm.sh/chart" (printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_")
}}
{{- range $key, $value := .Values.extraLabels }}{{- $_ := set $labels $key $value }}{{- end }}
{{- toYaml $labels }}
{{- end }}
{{- define "application-helmchart.annotations" -}}
{{- toYaml .Values.extraAnnotations }}
{{- end }}
{{- define "application-helmchart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "application-helmchart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
{{- define "application-helmchart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "application-helmchart.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "application-helmchart.databaseSecretName" -}}
{{- printf "%s-database-credentials" (include "application-helmchart.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "application-helmchart.databaseTagName" -}}
{{- $name := required "database.name is required when database.enabled is true" .Values.database.name }}
{{- printf "%s-%s-%s" .Values.projectName .Values.environment $name | trunc 255 | trimSuffix "-" }}
{{- end }}
{{- define "application-helmchart.databaseTags" -}}
{{- $tags := dict
      "Name" (include "application-helmchart.databaseTagName" .)
      "Project" .Values.projectName
      "crossplane-name" (include "application-helmchart.databaseTagName" .)
      "ManagedBy" "crossplane"
      "Environment" .Values.environment
}}
{{- range $key, $value := .Values.database.secretTags }}{{- $_ := set $tags $key $value }}{{- end }}
{{- toYaml $tags }}
{{- end }}
