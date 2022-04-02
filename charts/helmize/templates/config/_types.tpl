{{/* Config <Type>

  Defines the Type Definition for the configuration
  
*/}}
{{- define "inventory.config.types.config" -}}
{{- include "inventory.dropins.defaults.tpls_dir" $ }}:
  types: [ "string" ]
{{ include "inventory.conditions.defaults.inv_dir" $ }}:
  types: [ "string" ]
{{ include "inventory.dropins.defaults.dropins" $ }}:
  types: [ "slice" ]
{{ include "inventory.conditions.defaults.conditions" $ }}:
  types: [ "slice" ]
{{ include "inventory.entrypoint.defaults.force" $ }}:
  types: [ "bool", "int" ]
  default: false
{{ include "inventory.render.defaults.file.merge_strategy" $ }}:
  types: [ "string" ]
  default: "path"
  values: [ "file", "path" ]
{{ include "inventory.render.defaults.file.excludes" $ }}:
  types: [ "string", "slice" ]
{{ include "inventory.render.defaults.file.extensions" $ }}:
  types: [ "string", "slice" ]
  default: [ ".yaml", ".yml", ".tpl" ]
{{ include "inventory.render.defaults.files.identifier_template" $ }}:
  types: [ "string" ]
  default: "inventory.render.func.files.identifier.template" 
{{- end -}}