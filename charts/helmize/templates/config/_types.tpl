{{/* Config <Type>

  Defines the Type Definition for the configuration
  
*/}}
{{- define "inventory.config.types.config" -}}
{{ include "inventory.conditions.defaults.inv_dir" $ }}:
  types: [ "string" ]
{{ include "inventory.conditions.defaults.conditions" $ }}:
  types: [ "slice" ]
{{ include "inventory.entrypoint.defaults.force" $ }}:
  types: [ "bool", "int" ]
  default: false
{{ include "inventory.render.defaults.file.excludes" $ }}:
  types: [ "string", "slice" ]
{{ include "inventory.render.defaults.file.extensions" $ }}:
  types: [ "string", "slice" ]
  default: [ ".yaml", ".yml", ".tpl" ]
{{ include "inventory.render.defaults.files.identifier_template" $ }}:
  types: [ "string" ]
  default: "inventory.render.func.files.identifier.template" 
{{ include "inventory.postrenders.defaults.cfg.post_renderers" $ }}:
  types: [ "slice" ]
  default: [ "{{ include "inventory.postrenders.defaults.cfg.post_renderers.inject_key" $ }}" ]
{{ include "inventory.render.types.file_configuration" $ }}
{{- end -}}