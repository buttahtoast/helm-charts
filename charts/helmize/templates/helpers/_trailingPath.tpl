{{- define "inventory.helpers.trailingPath" -}}
  {{- printf "%s" ($ | trimPrefix "/" | trimPrefix "./" | trimSuffix "/") -}}
{{- end -}}