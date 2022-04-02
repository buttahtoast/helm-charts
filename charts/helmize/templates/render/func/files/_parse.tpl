{{/* Parse <Template>

  Parse a given file's content and apply sprig templating

  NOTE: It's considered an error if the given file does return empty (meaning it's empty or does not exist).
    If the content is empty after applying sprig templating it's not considered an error.

  params <dict>: 
    identifier: Optional <string> Predefined identifier for file
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
    {{- $return := dict "files" list "errors" list -}}
    {{- $context := $.ctx | deepCopy -}}

    {{/* Fet Full Filename */}}
    {{- $file := $.parse.file -}}

    {{/*Extend Identifier Context */}}
    {{- $path := dir $file -}}
    {{- with $.parse.path -}}
      {{- $path = . -}}
    {{- end -}}

    {{/* Identifier for file */}}
    {{- $id := dict "file" $file "path" $path "filename" (base $file) "fix" (default "" $.identifier) -}}

    {{/* Extra Context */}}
    {{- if and $.extra_ctx (kindIs "map" $.extra_ctx) -}}
      {{- $_ := set $context (default "inv" $.extra_ctx_key) $.extra_ctx -}}
    {{- else -}}
      {{- $_ := set $context (default "inv" $.extra_ctx_key) dict -}}
    {{- end -}}
    {{- $_ := set $context "file" $file -}}

    {{/* Get file content */}}
    {{- $content := ($.ctx.Files.Get $file) | deepCopy -}}

    {{/* Check if Content */}}
    {{- if $content -}}

      {{/* Variables */}}
      {{- $yaml_delimiter := "\n---\n" -}}
      {{- $filename_used := 0 -}}
      {{- $partial_files := splitList $yaml_delimiter $content -}}

      {{/* For Each File Execute Templating */}}
      {{- range $partial_files -}}

        {{/* File Struct */}}
        {{- $partial_file := dict "id" "" "content" "" "debug" list "errors" list -}}
  
        {{/* Template Content */}}
        {{- $template_content_raw := tpl . $context -}}
        {{- $templated_content := (fromYaml ($template_content_raw) | deepCopy) -}}
  
        {{/* Validate if conversation was successful, otherwise return with error */}}
        {{- if not (include "lib.utils.errors.unmarshalingError" $templated_content) -}}

          {{/* Evaluate Identifier */}}
          {{- $template_id := fromYaml (include "inventory.render.func.files.identifier" (dict "id" $id "content" $templated_content "ctx" $context "partial" $partial_file)) -}}
          {{- if $template_id.errors -}}
            {{- $_ := set $partial_file "errors" (concat $return.errors $template_id.errors) -}}
          {{- else -}}

            {{/* Evaluate if in current File loop the filename was already used. If it's an error */}}
            {{- if (eq $template_id.id $id.filename) -}}
              {{- if $filename_used -}}
                {{- $err := dict "error" (printf "Found multiple resources with identifier %s. Make sure they are unique." $id.filename) -}}
                {{- $_ := set $partial_file "errors" (append $return.errors $err) -}}
              {{- else -}}
                {{/* Set If it's used for the first time */}}
                {{- $filename_used = 1 -}}
                {{- $_ := set $partial_file "id" $template_id.id -}}
              {{- end -}}
            {{- else -}}
               {{- $_ := set $partial_file "id" $template_id.id -}}
            {{- end -}}
          {{- end -}}

          {{/* Store Content as Multi-YAML. FromYaml attempts to merge the content fields if multiple files are returned for any reason. As Multiline, this does not happen */}}
          {{- $_ := set $partial_file "content" (toYaml $templated_content) -}}

          {{/* Append File as Returnable */}}
          {{- $_ := set $return "files" (append $return.files $partial_file) -}}

        {{- else -}}
          {{- $_ := set $return "errors" (list (dict "error" $templated_content.Error "file" "empty" "trace" $template_content_raw)) -}}
        {{- end -}}
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