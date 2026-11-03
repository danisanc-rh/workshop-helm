{{/*
Nombre corto del chart.
*/}}
{{- define "customer-portal.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Nombre único de la release.
*/}}
{{- define "customer-portal.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "customer-portal.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Nombre del ServiceAccount: uno creado por el chart o uno preexistente.
*/}}
{{- define "customer-portal.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "customer-portal.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Labels comunes. helm.sh/chart identifica el chart y su versión.
*/}}
{{- define "customer-portal.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | quote }}
{{ include "customer-portal.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
{{- end -}}

{{/*
Labels estables para selector; no incluir versión ni chart version.
*/}}
{{- define "customer-portal.selectorLabels" -}}
app.kubernetes.io/name: {{ include "customer-portal.name" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end -}}
