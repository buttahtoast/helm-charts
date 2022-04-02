{{/* Multi YAML <Template>

  params <dict>: 
    parse: Required <dict>
      file: Required <string> FilePath
      path: Optional <string> Path to file
    extra_ctx: Optional <dict> Extra variables that are available during templating
    extra_ctx_key: Optional <string> Under which top key the given extra variables are publishes. Defaults to 'inv'
    ctx: Required <dict> Global Context

  returns <dict>:
    identifier: <string> Identifier for the file. Defaults to the filename without it's path.
    content: <dict> Parsed Content from file
    errors: <slice> Errors encoutered during parsing


*/}}
{{- define "inventory.render.func.files.identifier" -}}
  {{- if and $.id $.content $.ctx -}}

    {{/* Index Path based on Merge Strategy (Default) */}}
    {{- $return := dict "id" $.id.filename "errors" list -}}
    
    {{/* Run Identifiert Template */}}
    {{- $tpl := (fromYaml (include "inventory.config.func.resolve" (dict "path" (include "inventory.render.defaults.files.identifier_template" $.ctx) "ctx" $.ctx))).res -}}
    
    {{- if $tpl -}}
      {{/* included evaluated Template with current Root context */}}
      {{- $tpl_id_raw := include $tpl $ -}}
      {{- $tpl_id := fromYaml ($tpl_id_raw) -}}
      {{/* Evaluate if returned YAML is valid */}}
      {{- if (not (include "lib.utils.errors.unmarshalingError" $tpl_id)) -}}

        {{/* When the template returns errors, the id is not applied */}}
        {{- if $tpl_id.errors -}}
           {{- $_ := set $return "errors" (concat $return.errors $tpl_id.errors) -}}
        {{- else -}}
          {{/* Validate that returned id attribute has correct type */}}
          {{- if (kindIs "string" $tpl_id.id) -}}
            {{/* Validate if empty Id is allowed */}}
            {{- if $tpl_id.id -}}
              {{- $_ := set $return "id" $tpl_id.id -}}
            {{- else -}}
              {{- if not $tpl_id.allowEmptyIds -}}
                {{- $_ := set $return "errors" (append $return.errors (dict "error" (printf "Identifier Template '%s' returned empty id." $tpl))) -}}
              {{- end -}}
            {{- end -}}
          {{- else -}}
            {{- $_ := set $return "errors" (append $return.errors (dict "error" (printf "Identifier Template '%s' returned wrong type '%s'. Must be type 'str'" $tpl (kindOf $tpl_id.id)) "trace" $tpl_id_raw)) -}}
          {{- end -}}
        {{- end -}}

      {{- else -}}
        {{/* Id Template did not resolve correctly */}}
        {{- $_ := set $return "errors" (append $return.errors (dict "error" "Identifier Template YAML unmarshalingError" "trace" $tpl_id_raw)) -}}
      {{- end -}}
    {{- end -}}

    {{/* Return */}}
    {{- $_ := set $return "id" $.id.filename -}}
    {{- printf "%s" (toYaml $return) -}}

  {{- else -}}
    {{- include "lib.utils.errors.params" (dict "tpl" "inventory.render.files.multi_yaml" "params" (list "content " "ctx")) -}}
  {{- end -}}
{{- end -}}




{{/* Identifier Template <Template>

  This is the default Template used 

  params <dict>: 
    content: <dict> File Content
    id: <dict> File identifier
    ctx: Required <dict> Global Context

  returns <dict>:
    id: <string> Evaluated identifier
    allowEmptyIds: <bool> Tells the evaluating template if empty id values are allowed
    errors: <slice> Errors encoutered during parsing

*/}}
{{- define "inventory.render.func.files.identifier.template" -}}
  {{- $return := dict "id" "" "errors" list -}}
  {{- printf "%s" (toYaml $return) -}}
{{- end -}}


{{- define "inventory.render.func.files.identifier.template2" -}}
  {{- $return := dict "id" "" "errors" list -}}
  {{- if $.content.kind -}}
    {{- with $.content.metadata -}}
      {{- if .name -}}
        {{- $_ := set $return "id" (tpl "{{ $.content.kind }}-{{ $.content.metadata.name }}.yaml" (set ($.ctx | deepCopy) "content" $.content | deepCopy) | lower) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- printf "%s" (toYaml $return) -}}
{{- end -}}