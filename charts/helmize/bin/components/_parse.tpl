{{- define "inventory.components.parse" -}}
  {{- if and $.file $.ctx -}}
    {{- $file := $.file.file -}}
    {{- $path := $.file.path -}}
    {{- $filename := base $file -}}

    {{/* Index Path based on Merge Strategy */}}
    {{- $index := $filename -}}
    {{- if eq ((fromYaml (include "inventory.config.resolve" (dict "path" "file.merge_strategy" "ctx" $.ctx))).res) "path" -}}
      {{- $index = (regexReplaceAll $path $file "${1}" | trimPrefix "/") -}}
    {{- end -}}

    {{/* Return */}}
    {{- $return := dict "identifier" $index "files" (list $file) "content" dict "errors" list -}}

    {{/* Prepare Context */}}
    {{- $context := $.ctx -}}
    {{- if $.cpt -}}
      {{- $_ := set $context "Component" $.cpt -}}
    {{- end -}}
    {{- if $.groups -}}
      {{- $_ := set $context "Groups" $.groups -}}
    {{- end -}}
    {{/* Get file content */}}
    {{- $content := ($.ctx.Files.Get $file) -}}
    {{- if $content -}}
      {{/* Template Content */}}
      {{- $t := tpl $content $context }}
      {{- $templated_content := fromYaml ($t) -}}
      {{/* Validate if conversation was successful, otherwise return with error */}}
      {{- if not (include "inventory.helpers.unmarshalingError" $templated_content) -}}
        {{- $_ := set $return "content" $templated_content -}}
      {{- else -}}
        {{- $_ := set $return "errors" (list (dict "error" $templated_content.Error "file" $file)) -}}
      {{- end -}}
    {{- end -}}
    {{/* Always Return */}}
    {{- printf "%s" (toYaml $return) -}}
  {{- end -}}
{{- end -}}