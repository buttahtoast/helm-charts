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
  {{- if and $.wagon $.ctx -}}

    {{/* Run Identifiert Template */}}
    {{- $identifier_tpl_name := (fromYaml (include "inventory.config.func.resolve" (dict "path" (include "inventory.render.defaults.files.identifier_template" $.ctx) "ctx" $.ctx))).res -}}
    {{- if $identifier_tpl_name -}}

      {{/* included evaluated Template with current Root context */}}
      {{- include $identifier_tpl_name $ -}}

      {{/* Handle ID */}}
      {{- if not ($.wagon.id) -}}
        {{/* Set Filename as default, if nothing set */}}
        {{- $_ := set $.wagon "id" (list $.wagon.file_id.filename) -}}
      {{- else -}}
        {{/* Convert to List */}}
        {{- if not (kindIs "slice" $.wagon.id) -}}
          {{- $_ := set $.wagon "id" (list $.wagon.id) -}}
        {{- end -}}
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
{{- define "inventory.render.templates.identifier" -}}

  {{/* File has content */}}
  {{- if $.wagon.content -}}

    {{/* Check if dedicated id field is set */}}
    {{- if $.wagon.content.id -}}
      {{- if (kindIs "slice" $.wagon.content.id) -}}
        {{- $_ := set $.wagon "id" (concat $.wagon.id $.wagon.content.id) -}}
      {{- else -}}
        {{- $_ := set $.wagon "id" (append $.wagon.id $.wagon.content.id) -}}
      {{- end -}}
      {{- unset $.wagon.content "id" -}}
    {{- end -}}
  
  
    {{/* kind-name identifier */}}
    {{- if $.wagon.content.kind -}}
      {{- with $.wagon.content.metadata -}}
        {{- if .name -}}
          {{- $_ := set $.wagon "id" (append $.wagon.id (printf "%s-%s.yaml" ($.wagon.content.kind | lower) ($.wagon.content.metadata.name | lower))) -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}

  {{- end -}}
{{- end -}}
