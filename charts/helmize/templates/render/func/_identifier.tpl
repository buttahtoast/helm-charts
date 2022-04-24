{{/* Identifier <Template>
  
  Calls Identifier Template
*/}}
{{- define "inventory.render.func.identifier" -}}
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
