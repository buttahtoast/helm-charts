{{/* Location <Template> 

  Config File location

*/}}
{{- define "inventory.config.defaults.location" -}}
  {{- default "helmize.yaml" $.Values.config_file -}}
{{- end }}