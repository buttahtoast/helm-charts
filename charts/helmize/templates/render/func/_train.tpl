{{/* Train <Template> 

  Gathers all relevant files based on given paths, extensions and exclusions and returns the paths

  params <dict>: 
    files: <strict> Paths to look for files
    ctx: <dict> Global Context

  returns <dict>:
    files <slice>: contains all files
    errors <int>: amount of errors during file collection
    
*/}}
{{- define "inventory.render.func.train" -}}
  {{- if and $.files $.ctx -}}
    {{- $return := dict "files" list "paths" list "errors" list "debug" list -}}

    {{/* Variables */}}
    {{- $file_train := list -}}
    {{- $yaml_delimiter := "\n---\n" -}}
    {{- $order := 0 -}}

    {{/* Shared Data Over All Files */}}
    {{- $shared_data := dict -}}

    {{/* Paths */}}
    {{- $_ := set $return "paths" $.files -}}

    {{/* Iterate over files */}}
    {{- range $file := $.files -}}
      {{- $train_file := dict "files" (list $file) "errors" list "debug" list -}}

      {{/* Parse File */}}
      {{- $file_name := $file.file -}}

      {{/* Benchmark */}}
      {{- include "inventory.helpers.ts" (dict "msg" (printf "File %s initialied" $file_name) "ctx" $.ts) -}}

      {{/* Merge Data Store */}}
      {{- $data := $shared_data -}}

      {{/* Identifier for file */}}
      {{- $file_id := dict "file" $file_name "path" (dir $file.path) "filename" (base $file_name) -}}

      {{/* Get Content */}}
      {{- $content := ($.ctx.Files.Get $file_name) -}}

      {{/* Check if Content */}}
      {{- if $content -}}

        {{/* Split Content by Delimiter */}}
        {{- $partial_files := splitList $yaml_delimiter $content -}}

        {{/* Iterate over Partial File */}}
        {{- range $partial_files -}}

          {{/* Initialize Context */}}
          {{- $context := $.ctx -}}
          {{- $matched := 0 -}}

          {{/* File Struct */}}
          {{- $incoming_wagon := dict "id" list "content" "" "file_id" $file_id "subpath" (regexReplaceAll $file_id.path $file_id.file "${1}" | trimPrefix "/" | dir) "debug" list "errors" list -}}

          {{/* Evaluate Content */}}
          {{- $template_content_raw := tpl . $context -}}
          {{- $templated_content := (fromYaml ($template_content_raw)) -}}

          {{/* Validate if conversation was successful, otherwise return with error */}}
          {{- if not (include "lib.utils.errors.unmarshalingError" $templated_content) -}}

            {{- $_ := set $incoming_wagon "content" $templated_content -}}


            {{/* Resolve File Configuration within file, if not set get empty dict */}}
            {{- $file_cfg := default dict (fromYaml (include "lib.utils.dicts.lookup" (dict "data" $templated_content "path" (include "inventory.render.defaults.file_cfg.key" $)))).res -}}
            {{- $_ := unset $templated_content (include "inventory.render.defaults.file_cfg.key" $) -}}
  
            {{/* Compares against Type */}}
            {{- $file_cfg_type := fromYaml (include "lib.utils.types.validate" (dict "type" "inventory.render.types.file_configuration"  "data" $file_cfg  "ctx" $.ctx)) -}}
            {{- if $file_cfg_type.isType -}}
              {{- $_ := set $incoming_wagon "cfg" $file_cfg -}}
            {{- else -}}
              {{/* Error Redirect */}}
              {{- $_ := set $incoming_wagon "errors" (append $incoming_wagon.errors (dict "error" "File has type errors" "type_errors" $file_cfg_type.errors)) -}}
            {{- end -}}

            {{/* Benchmark */}}
            {{- include "inventory.helpers.ts" (dict "msg" (printf "Running Identifier") "ctx" $.ts) -}}

            {{/* Evaluate Identifier */}}
            {{- include "inventory.render.func.files.identifier" (dict "wagon" $incoming_wagon "ctx" $context) -}}
             
            {{/* Benchmark */}}
            {{- include "inventory.helpers.ts" (dict "msg" (printf "Got Identifier") "ctx" $.ts) -}}

            {{/* Handle Errors (File Won't be merged) */}}
            {{- if $incoming_wagon.errors -}}
              {{- $_ := set $return "errors" (append $return.errors (dict "file" $file_name "errors" $incoming_wagon.errors)) -}}
            {{- else -}}

              {{/* Debug */}}
              {{- if (include "inventory.entrypoint.func.debug" $.ctx) -}}
                {{- $_ := set $incoming_wagon "files" (list (set (set (set $file "_order" $order) "config" $incoming_wagon.cfg) "ids" $incoming_wagon.id)) -}}
                {{- $_ := set $return "debug" (append $return.debug (dict "Source" $file.file "Manifest" $incoming_wagon)) -}}
              {{- end -}}

              {{/* Iterate Trough Train to find Matches */}}
              {{- range $i, $wagon := $file_train -}}

                {{/* Validate Subpath */}}
                {{- if or (not (get $incoming_wagon.cfg (include "inventory.render.defaults.file_cfg.subpath" $))) (and (get $incoming_wagon.cfg (include "inventory.render.defaults.file_cfg.subpath" $)) (eq $incoming_wagon.subpath $wagon.subpath)) -}}

                    {{/* ForEach incomfing ID iterate */}}
                    {{- range $id := $incoming_wagon.id -}}
                    
                      {{/* Check Against existing Wagon IDs */}}
                      {{- range $wagon_id := $wagon.id -}}
  
                        {{/* Checl Match */}}
                        {{- if or (eq $id $wagon_id) (and (get $incoming_wagon.cfg (include "inventory.render.defaults.file_cfg.pattern" $)) (regexFind $id $wagon_id)) -}}
  
                          {{/* Overwrite Matched */}}
                          {{- $matched = 1 -}}
    
                          {{/* Merge file Properties */}}
                          {{- with $incoming_wagon.files -}}
                            {{- $_ := set $wagon "files" (concat $wagon.files $incoming_wagon.files) -}}
                          {{- end -}}
    
                          {{/* Merge Contents */}}
                          {{- if $incoming_wagon.content -}}
                            {{- $_ := set $wagon "content" (mergeOverwrite (default dict $wagon.content) $incoming_wagon.content) -}}
                          {{- end -}}  
            
                          {{/* Increase Order */}}
                          {{- $order = addf $order 1 -}}

                      {{- end -}}
                    {{- end -}}
                  {{- end -}}
                {{- end -}}
              {{- end -}}

              {{/* Handle unmatched files */}}
              {{- if not ($matched) -}}

                {{/* Skip if pattern enabled */}}
                {{- if not (get $incoming_wagon.cfg (include "inventory.render.defaults.file_cfg.pattern" $)) -}}

                  {{/* Skip File if configured */}}
                  {{- if not (eq (get $incoming_wagon.cfg (include "inventory.render.defaults.file_cfg.no_match" $)) "skip") -}}
                    {{- $file_train = append $file_train (omit $incoming_wagon "cfg" "file_id") -}}
                    {{- $order = addf $order 1 -}}
                  {{- end -}}

                {{- end -}}
              {{- end -}}

            {{- end -}}
          {{- else -}}
             {{- $_ := set $return "errors" (list (dict "error" $templated_content.Error "file" "empty" "trace" $template_content_raw)) -}}
          {{- end -}}
        {{- end -}}
      {{- else -}}
        {{- $_ := set $return "errors" (list (dict "error" "File not found or empty content" "file" $file_name)) -}}
      {{- end -}}

      {{/* Benchmark */}}
      {{- include "inventory.helpers.ts" (dict "msg" (printf "File Executed") "ctx" $.ts) -}}

    {{- end -}}

    {{/* Conclude Train */}}
    {{- if $file_train -}}

      {{/* Benchmark */}}
      {{- include "inventory.helpers.ts" (dict "msg" "Running Post-Renderers" "ctx" $.ts) -}}

      {{/* Run PostRenderers */}}
      {{- range $file := $file_train -}}
        {{- include "inventory.postrenders.func.execute" (dict "file" $file "extra_ctx" $file.data "extra_ctx_key" (include "inventory.render.defaults.files.data_key" $) "ctx" $.ctx) -}}
      {{- end -}}

      {{/* Benchmark */}}
      {{- include "inventory.helpers.ts" (dict "msg" "Post-Renderers Done" "ctx" $.ts) -}}

      {{/* Benchmark */}}
      {{- include "inventory.helpers.ts" (dict "msg" "Running Checksums" "ctx" $.ts) -}}

      {{/* Post Manipulations */}}
      {{- range $file := $file_train -}}
        {{- with $file.content -}}
          {{- $_ := set $file "checksum" (sha256sum (toYaml .)) -}}
        {{- end -}}
      {{- end -}}

      {{/* Benchmark */}}
      {{- include "inventory.helpers.ts" (dict "msg" "Checksums Done" "ctx" $.ts) -}}

      {{/* Convert to Slice */}}
      {{- $_ := set $return "files" $file_train -}} 
    {{- end -}}

    {{/* Return */}}
    {{- printf "%s" (toYaml $return) -}}

  {{- end -}}
{{- end -}}