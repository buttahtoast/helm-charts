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
    {{- $id := dict "file" $file "path" $path "filename" (base $file) -}}

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
        {{- $partial_file := dict "id" list "content" "" "debug" list "errors" list -}}

        {{/* Template Content */}}
        {{- $template_content_raw := tpl . $context -}}
        {{- $templated_content := (fromYaml ($template_content_raw) | deepCopy) -}}

        {{/* Validate if conversation was successful, otherwise return with error */}}
        {{- if not (include "lib.utils.errors.unmarshalingError" $templated_content) -}}

          {{/* Resolve File Configuration within file, if not set get empty dict */}}
          {{- $file_cfg := default dict (fromYaml (include "lib.utils.dicts.lookup" (dict "data" $templated_content "path" (include "inventory.render.defaults.file_cfg.key" $)))) -}}

          {{/* Compares against Type */}}
          {{- $file_cfg_type := fromYaml (include "lib.utils.types.validate" (dict "type" "inventory.render.types.file_configuration"  "data" $file_cfg  "ctx" $.ctx)) -}}
          {{- if $file_cfg_type.isType -}}
            {{- $_ := set $partial_file "cfg" $file_cfg -}}
          {{- else -}}
            {{/* Error Redirect */}}
            {{- $_ := set $partial_file "errors" (append $partial_file.errors (dict "error" "File has type errors" "type_errors" $file_cfg_type.errors)) -}}
          {{- end -}}

          {{/* Evaluate Identifier */}}
          {{- include "inventory.render.func.files.identifier" (dict "id" $id "content" $templated_content "ctx" $context "file" $partial_file) -}}

          {{/* Get Data Context From Content */}}
          {{- $data_key := include "inventory.render.defaults.files.data_key" $ -}}
          {{- if (get $templated_content $data_key) -}}
            {{- $shared_data := (get $templated_content $data_key) -}}

            {{/* Extract to Extra Content Pointer */}}
            {{- if (kindIs "map" $shared_data) -}}
               {{- $_ := set $ "shared_data" (mergeOverwrite $.shared_data $shared_data) -}}
            {{- end -}}
            
            {{/* Unset Data in Content */}}
            {{- $_ := unset $templated_content $data_key -}}

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