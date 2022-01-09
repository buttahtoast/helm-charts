{{/* Get <Template> 

  Read Configuration Content

  params <dict>: Global Context
  returns <dict>: Configuration File content

*/}}
{{- define "inventory.config.func.get" -}}
  {{- $cfg_loc := (include "inventory.config.defaults.location" $) -}}

  {{/* Validate based on type how config is set */}}
  {{- $cfg := fromYaml (.Files.Get $cfg_loc) -}}

  {{/* When config has values */}}
  {{- if $cfg -}}

    {{/* Validate Configuration */}}
    {{- $cfg_validate := fromYaml (include "lib.utils.types.validate" (dict "type" "inventory.config.types.config" "data" $cfg "ctx" $)) -}}
    {{- if $cfg_validate.isType -}}
      {{- printf "%s" (toYaml $cfg) -}}
    {{- else -}}
      {{- include "lib.utils.errors.fail" (printf "Config Validation failed:\n%s" (toYaml $cfg_validate.errors | nindent 2)) -}}
    {{- end -}}

  {{- else }}
    {{- include "lib.utils.errors.fail" (printf "Empty Configuration Content for %s is the file present?" $cfg_loc) -}}
  {{- end }}
{{- end }}