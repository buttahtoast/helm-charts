{{/* Location <Template> 

  Config File location

*/}}
{{- define "inventory.config.defaults.location" -}}
  {{- default "_config.yaml" $.Values.config_file -}}
{{- end }}