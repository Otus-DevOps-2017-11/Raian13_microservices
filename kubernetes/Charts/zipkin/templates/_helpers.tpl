{{- define "zipkin.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name }}
{{- end -}}