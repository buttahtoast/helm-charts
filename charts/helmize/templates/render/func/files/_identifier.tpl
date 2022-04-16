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

    {{/* ID Defaults to Filename */}}
    {{- $_ := set $.file "id" (list $.id.filename) -}}

    {{/* Run Identifiert Template */}}
    {{- $identifier_tpl_name := (fromYaml (include "inventory.config.func.resolve" (dict "path" (include "inventory.render.defaults.files.identifier_template" $.ctx) "ctx" $.ctx))).res -}}
    {{- if $identifier_tpl_name -}}

      {{/* included evaluated Template with current Root context */}}
      {{- $tpl_identifier_raw := include $identifier_tpl_name $ -}}
      {{- $tpl_identifier := fromYaml ($tpl_identifier_raw) -}}

      {{/* Add Debug Information */}}
      {{- with $tpl_identifier.debug -}}
         {{- $_ := set $.file "debug" (append $.file.debug (dict "template" $identifier_tpl_name "trace" (toYaml .))) -}}
      {{- end -}}

      {{/* Evaluate if returned YAML is valid */}}
      {{- if (not (include "lib.utils.errors.unmarshalingError" $tpl_identifier)) -}}

        {{/* Append Errors */}}
        {{- if $tpl_identifier.errors -}}
           {{- $_ := set $.file "errors" (concat $.file.errors $tpl_identifier.errors) -}}
        {{- else -}}

          {{/* Validate that returned id attribute has correct type */}}
          {{- if (kindIs "slice" $tpl_identifier.id) -}}
            {{/* Validate if empty Id is allowed */}}
            {{- if $tpl_identifier.id -}}
              {{- $_ := set $.file "id" $tpl_identifier.id -}}
            {{- else -}}
              {{/* Check if Template enforces ID */}}
              {{- if $tpl_identifier.requireId -}}
                {{- $_ := set $.file "errors" (append $.file.errors (dict "error" (printf "Identifier Template '%s' returned empty id." $identifier_tpl_name))) -}}
              {{- end -}}
            {{- end -}}
          {{- else -}}
            {{- $_ := set $.file "errors" (append $.file.errors (dict "error" (printf "Identifier Template '%s' returned wrong type '%s'. Must be type 'str'" $identifier_tpl_name (kindOf $tpl_identifier.id)) "trace" $tpl_identifier_raw)) -}}
          {{- end -}}

        {{- end -}}

      {{- else -}}
        {{/* Id Template did not resolve correctly */}}
        {{- $_ := set $.file "errors" (append $.file.errors (dict "error" "Identifier Template YAML unmarshalingError" "trace" $tpl_identifier_raw)) -}}
      {{- end -}}
    {{- end -}}
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
    id: <slice> Evaluated identifier(s)
    allowEmptyIds: <bool> Tells the evaluating template if empty id values are allowed
    errors: <slice> Errors encoutered during parsing

*/}}
{{- define "inventory.render.func.files.identifier.template" -}}
  {{- $return := dict "id" list "errors" list "debug"  -}}

  {{/* Check if dedicated id field is set */}}
  {{- if $.content.id -}}
    {{- if (kindIs "slice" $.content.id) -}}
      {{- $_ := set $return "id" (concat $return.id $.content.id) -}}
    {{- else -}}
      {{- $_ := set $return "id" (append $return.id ) -}}
    {{- end -}}
    {{- unset $.content "id" -}}
  {{- end -}}

  {{/* kind-name identifier */}}
  {{- if $.content.kind -}}
    {{- with $.content.metadata -}}
      {{- if .name -}}
        {{- $_ := set $return "id" (append $return.id ((tpl "{{ $.content.kind }}-{{ $.content.metadata.name }}.yaml" (set ($.ctx | deepCopy) "content" $.content | deepCopy) | lower))) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{/* Return given */}}
  {{- printf "%s" (toYaml $return) -}}

{{- end -}}
