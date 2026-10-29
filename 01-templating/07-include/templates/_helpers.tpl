{{- define "workshop.appName" -}}
{{- printf "%s-%s" .Values.app.name .Values.app.suffix -}}
{{- end -}}
