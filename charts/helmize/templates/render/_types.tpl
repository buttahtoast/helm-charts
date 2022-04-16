{{/* Config <Type>

  Defines the Type Definition for the configuration
  
*/}}
{{- define "inventory.render.types.file_configuration" -}}
{{ include "inventory.render.defaults.file_cfg.match" $ }}:
  types: [ "string" ]
  default: "all"
  values: [ "single", "all" ]
{{ include "inventory.render.defaults.file_cfg.no_match" $ }}:
  types: [ "string" ]
  default: "append"
  values: [ "append", "skip" ]
{{ include "inventory.render.defaults.file_cfg.multi_filename" $ }}:
  types: [ "bool" ]
  default: false
{{ include "inventory.render.defaults.file_cfg.subpath" $ }}:
  types: [ "bool" ]
  default: true
{{ include "inventory.render.defaults.file_cfg.expand" $ }}:
  types: [ "bool" ]
  default: false
{{ include "inventory.render.defaults.file_cfg.pattern" $ }}:
  types: [ "bool" ]
  default: false
{{- end -}}