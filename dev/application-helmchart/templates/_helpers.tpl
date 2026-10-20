{{- define "application-helmchart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- define "application-helmchart.fullname" -}}
{{- default (include "application-helmchart.name" .) .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- define "application-helmchart.labels" -}}
app.kubernetes.io/name: {{ include "application-helmchart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | quote }}
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
