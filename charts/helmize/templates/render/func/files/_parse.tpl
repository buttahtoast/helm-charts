{{/* Parse <Template>

  Parse a given file's content and apply sprig templating

  NOTE: It's considered an error if the given file does return empty (meaning it's empty or does not exist).
    If the content is empty after applying sprig templating it's not considered an error.

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
{{- define "inventory.render.func.files.parse" -}}
  {{- if and $.parse $.ctx -}}

    {{/* Variables */}}
    {{- $file := $.parse.file -}}
    {{- $path := dir $file -}}
    {{- with $.parse.path -}}
      {{- $path = . -}}
    {{- end -}}
    {{- $filename := base $file -}}

    {{/* Index Path based on Merge Strategy */}}
    {{- $index := $filename -}}
    {{- if eq ((fromYaml (include "inventory.config.func.resolve" (dict "path" (include "inventory.render.defaults.file.merge_strategy" $.ctx) "ctx" $.ctx))).res) "path" -}}
      {{- $index = (regexReplaceAll $path $file "${1}" | trimPrefix "/") -}}
    {{- end -}}

    {{/* Return */}}
    {{- $return := dict "identifier" $index "content" dict "errors" list -}}

    {{/* Extra Context */}}
    {{- $context := $.ctx -}}
    {{- if and $.extra_ctx (kindIs "map" $.extra_ctx) -}}
      {{- $_ := set $context (default "inv" $.extra_ctx_key) $.extra_ctx -}}
    {{- else -}}
      {{- $_ := set $context (default "inv" $.extra_ctx_key) dict -}}
    {{- end -}}

    {{/* Get file content */}}
    {{- $content := ($.ctx.Files.Get $file) -}}

    {{/* Check if Content */}}
    {{- if $content -}}

      {{/* Template Content */}}
      {{- $template_content_raw := tpl $content $context -}}
      {{- $templated_content := fromYaml ($template_content_raw) -}}

      {{/* Validate if conversation was successful, otherwise return with error */}}
      {{- if not (include "lib.utils.errors.unmarshalingError" $templated_content) -}}
        {{- $_ := set $return "content" $templated_content -}}
      {{- else -}}
        {{- $_ := set $return "errors" (list (dict "error" $templated_content.Error "file" $file "trace" $template_content_raw)) -}}
      {{- end -}}

    {{- else -}}  
      {{- $_ := set $return "errors" (list (dict "error" "File not found or empty content" "file" $file)) -}}
    {{- end -}}

    {{/* Always Return */}}
    {{- printf "%s" (toYaml $return) -}}

  {{- else -}}
    {{- include "lib.utils.errors.params" (dict "tpl" "inventory.render.files.parse" "params" (list "parse" "ctx")) -}}
  {{- end -}}
{{- end -}}