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
    {{- $return := dict "files" list "errors" list "debug" list -}}

    {{/* Variables */}}
    {{- $file_train := list -}}
    {{- $order := 0 -}}

    {{/* Shared Data Over All Files */}}
    {{- $shared_data := dict -}}

    {{/* Iterate over files */}}
    {{- range $file := $.files -}}
      {{- $train_file := dict "files" (list $file) "errors" list "debug" list -}}

      {{/* Benchmark */}}
      {{- include "inventory.helpers.ts" (dict "msg" (printf "File %s initialied" $file.file) "ctx" $.ts) -}}


      {{/* Merge Data Store */}}
      {{- $data := $shared_data -}}

      {{/* Parse file(s) */}}
      {{- $train_file_contents_raw := include "inventory.render.func.files.parse" (dict "parse" ($file) "extra_ctx" $data "extra_ctx_key" "Data" "shared_data" $shared_data "ctx" $.ctx) -}}
      {{- $train_file_contents := fromYaml ($train_file_contents_raw) -}}
      {{- if (not (include "lib.utils.errors.unmarshalingError" $train_file_contents)) -}}

        {{/* Foreach resolved file */}}
        {{- range $incoming_wagon := $train_file_contents.files -}}

 
          {{/* Persist Identifier */}}
          {{- $ids := $incoming_wagon.id -}}

          {{/* If any IDs present */}}
          {{- if $ids -}}

            {{/* Match Config Control Variables */}}
            {{- $matched := 0 -}}

            {{/* Preserve Data for File (Post-Rendering) */}}
            {{- $_ := set $incoming_wagon "data" (mergeOverwrite $data $shared_data) -}}

            {{/* Debug */}}
            {{- if (include "inventory.entrypoint.func.debug" $.ctx) -}}

              {{/* Add Current File as Files (Assign Order) */}}
              {{- $_ := set $incoming_wagon "files" (list (set (set $file "_order" $order) "config" $incoming_wagon.cfg)) -}}

              {{- $_ := set $return "debug" (append $return.debug (dict "Source" $file.file "Manifest" $incoming_wagon)) -}}
            {{- end -}}

            {{/* Parse Content, if not map */}}
            {{- if $incoming_wagon.content -}}
              {{- if not (kindIs "map" $incoming_wagon.content) -}}
                {{- $parsed_content := (fromYaml ($incoming_wagon.content)) -}}
                {{- if (not (include "lib.utils.errors.unmarshalingError" $parsed_content)) -}}
                  {{- $_ := set $incoming_wagon "content" $parsed_content -}}
                {{- else -}}
                  {{- $_ := set $return "errors" (append $return.errors (dict "file" $file.file "errors" "Content not YAML" "trace" ($incoming_wagon.content))) -}}
                {{- end -}}
              {{- end -}}
            {{- end -}}


            {{/* Handle Errors (File Won't be merged) */}}
            {{- if $incoming_wagon.errors -}}
              {{- $_ := set $return "errors" (append $return.errors (dict "file" $file.file "errors" $incoming_wagon.errors)) -}}
            {{- else -}}

              {{/* Iterate Trough Train to find Matches */}}
              {{- range $i, $wagon := $file_train -}}

                {{/* Check if matched and single */}}
                {{- if not (and ($matched) (eq (get $incoming_wagon.cfg (include "inventory.render.defaults.file_cfg.match" $)) "single")) -}}

                  {{/* Validate Subpath */}}
                  {{- if or (not (get $incoming_wagon.cfg (include "inventory.render.defaults.file_cfg.subpath" $))) (and (get $incoming_wagon.cfg (include "inventory.render.defaults.file_cfg.subpath" $)) (eq (default "" $incoming_wagon.subpath) (default "" $wagon.subpath)))  -}}

                    {{/* ForEach incomfing ID iterate */}}
                    {{- range $id := $ids -}}
                    
                      {{/* Check Against existing Wagon IDs */}}
                      {{- range $wagon_id := $wagon.id -}}
  
                        {{/* Checl Match */}}
                        {{- if eq $id $wagon_id -}}
  
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
              {{- end -}}

              {{/* Handle unmatched files */}}
              {{- if not ($matched) -}}

                {{/* Skip if pattern enabled */}}
                {{- if not (get $incoming_wagon.cfg (include "inventory.render.defaults.file_cfg.pattern" $)) -}}

                  {{/* Skip File if configured */}}
                  {{- if not (eq (get $incoming_wagon.cfg (include "inventory.render.defaults.file_cfg.no_match" $)) "skip") -}}
                    {{- $file_train = append $file_train (omit $incoming_wagon "cfg") -}}
                    {{- $order = addf $order 1 -}}
                  {{- end -}}

                {{- end -}}
              {{- end -}}
            {{- end -}}
          {{- end -}}
        {{- end -}}
      {{- end -}}

      {{/* Benchmark */}}
      {{- include "inventory.helpers.ts" (dict "msg" (printf "File %s Executed" $file.file) "ctx" $.ts) -}}

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
        {{/* Add Checksum */}}
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