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
      {{- $partial_files := splitList $yaml_delimiter $content -}}

      {{/* For Each File Execute Templating */}}
      {{- range $partial_files -}}

        {{- $partial_file := dict "identifiers" list "content" "" "errors" list -}}
  
        {{/* Template Content */}}
        {{- $template_content_raw := tpl . $context -}}
        {{- $templated_content := (fromYaml ($template_content_raw) | deepCopy) -}}
  
        {{/* Validate if conversation was successful, otherwise return with error */}}
        {{- if not (include "lib.utils.errors.unmarshalingError" $templated_content) -}}

          {{/* Evaluate Identifier */}}
          {{- $identifiers := fromYaml (include "inventory.render.func.files.identifier" (dict "id" $id "content" $templated_content "ctx" $context)) -}}
          {{- if $identifiers.errors -}}
            {{- $_ := set $partial_file "errors" (concat $return.errors $identifiers.errors) -}}
          {{- else -}}
            {{- $_ := set $partial_file "identifiers" $identifiers.identifiers -}}
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
    {{- $return := dict "identifiers" list "errors" list -}}

    {{/* Identifiers */}}
    {{- $ids := list -}}

    {{/* Index Path based on Merge Strategy (Default) */}}
    {{- $auto_index := $.id.filename -}}
    
    {{/* Validate Kind-Name identifier */}}
    {{- if $.content.kind -}}
      {{- with $.content.metadata -}}
        {{- if .name -}}
          {{- $auto_index = (tpl "{{ $.content.kind }}-{{ $.content.metadata.name }}.yaml" (set ($.ctx | deepCopy) "content" $.content | deepCopy) | lower) -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}

    {{/* Add Auto Index as Identifier */}}
    {{- $ids = append $ids $auto_index -}}

    {{/* Reads Inline identifiers and removes them */}}
    {{- if $.content.identifiers -}}

      {{- $ids = concat $ids $.content.identifiers -}}
      {{- $_ := set $ "content" (omit $.content "identifiers") -}}

    {{- end -}}

    {{/* Merge Path strategy for all */}}
    {{- if eq ((fromYaml (include "inventory.config.func.resolve" (dict "path" (include "inventory.render.defaults.file.merge_strategy" $.ctx) "ctx" $.ctx))).res) "path" -}}
      {{- range $index := $ids -}}
        {{- $index = printf "%s/%s" (regexReplaceAll $.id.path (dir $.id.file) "${1}" | trimPrefix "/") $index -}}
      {{- end -}}
    {{- end -}}
    {{- $_ := set $return "identifiers" $ids -}}

    {{/* Return */}}
    {{- printf "%s" (toYaml $return) -}}

  {{- else -}}
    {{- include "lib.utils.errors.params" (dict "tpl" "inventory.render.files.multi_yaml" "params" (list "content " "ctx")) -}}
  {{- end -}}
{{- end -}}




