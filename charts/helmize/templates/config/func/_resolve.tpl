{{/* Resolve <Template> 

  Get a specific key path from the config

  params <dict>: 
    path: <dict> Role to resolve
    req: <bool> If required and the value does not exist, the template will fail
    ctx: <dict> Global Context

  returns <string>: Value from given path

*/}}
{{- define "inventory.config.func.resolve" -}}
  {{- if and $.path $.ctx }}
    {{- $tpl := default false $.tpl -}}

    {{/* Resolve configuration */}}
    {{- $cfg := fromYaml (include "inventory.config.func.get" $.ctx) -}}
    {{- $result := include "lib.utils.dicts.lookup" (dict "data" $cfg "path" $.path "required" (default false $.req)) }}
    {{- printf "%s" ($result) -}}

  {{- else -}}
    {{- include "lib.utils.errors.params" (dict "tpl" "inventory.render.files.parse" "params" (list "path" "ctx")) -}}
  {{- end -}}
{{- end -}}