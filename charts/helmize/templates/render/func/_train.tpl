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
    {{- $file_train := dict -}}
    {{- $order := 0 -}}

    {{/* Shared Data Over All Files */}}
    {{- $shared_data := dict -}}

    {{/* Iterate over files */}}
    {{- range $file := $.files -}}
      {{- $train_file := dict "files" (list $file) "errors" list "debug" list -}}

      {{/* Resolve Dropins for current path */}}
      {{- $dropins_data := dict -}}
      {{- $dropins := fromYaml (include "inventory.dropins.func.resolve" (dict "path" $file.file "ctx" $.ctx)) -}}
      {{- if (not (include "lib.utils.errors.unmarshalingError" $dropins)) -}}
    
        {{/* Redirect Errors */}}
        {{- with $dropins.errors -}}
          {{- $_ := set $train_file "errors" (concat $train_file.errors .) -}}
        {{- end -}}

        {{/* Redirect Data */}}
        {{- with $dropins.data -}}
          {{- $dropins_data = . -}}
        {{- end -}}

      {{- end -}}

      {{/* Merge Data Store with Dropins */}}
      {{- $data := mergeOverwrite $dropins_data $shared_data -}}

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
            {{- $matched := 1 -}}

            {{/* Preserve Data for File (Post-Rendering) */}}
            {{- $_ := set $incoming_wagon "data" (mergeOverwrite $data $shared_data) -}}

            {{/* Add Current File as Files (Assign Order) */}}
            {{- $_ := set $incoming_wagon "files" (list (set $file "_order" $order)) -}}

            {{/* Debug */}}
            {{- if (include "inventory.entrypoint.func.debug" $.ctx) -}}
              {{- $_ := set $return "debug" (append $return.debug (dict "Source" $file.file "Manifest" $incoming_wagon "Dropins" $dropins)) -}}
            {{- end -}}

            {{/* Handle Errors (File Won't be merged) */}}
            {{- if $incoming_wagon.errors -}}
              {{- $_ := set $return "errors" (append $return.errors (dict "file" $file.file "errors" $incoming_wagon.errors)) -}}
            {{- else -}}

              {{/* Parse Content, if not map */}}
              {{- if not (kindIs "map" $incoming_wagon.content) -}}
                {{- $_ := set $incoming_wagon "content" (fromYaml ($incoming_wagon.content)) -}}
              {{- end -}}

              {{/* File can have multiple ids */}}
              {{- range $id := $ids -}}

                {{/* Check if matched and single */}}
                {{- if not (and ($matched) (eq (get $incoming_wagon.cfg (include "inventory.render.defaults.file_cfg.match" $)) "single")) -}}

                  {{/* Check if any file with the same identifier is already present */}}
                  {{- $wagon := (get $file_train $id) -}}

                  {{/* Match for given ID */}}
                  {{- if $wagon -}}

                    {{/* Overwrite Matched */}}
                    {{- $matched = 0 -}}
                     
                    {{/* Merge file Properties */}}
                    {{- with $incoming_wagon.files -}}
                      {{- $_ := set $wagon "files" (concat $wagon.files $incoming_wagon.files) -}}
                    {{- end -}}  
        
                    {{/* Merge Contents */}}
                    {{- if $incoming_wagon.content -}}
                      {{- $_ := set $wagon "content" (mergeOverwrite (default dict $wagon.content) $incoming_wagon.content) -}}
                    {{- end -}}  
        
                    {{/* Update Wagon */}}
                    {{- $_ := set $file_train $id $wagon -}}
        
                  {{/* No Match for given ID */}}
                  {{- else -}}

                    {{/* Skip File if configured */}}
                    {{- if not (eq (get $incoming_wagon.cfg (include "inventory.render.defaults.file_cfg.no_match" $)) "skip") -}}
        
                      {{/* Add File as new file */}}
                      {{- $_ := set $file_train $id $incoming_wagon -}}

                    {{- end -}}
                  {{- end -}}

                  {{/* Increase Order */}}
                  {{- $order = addf $order 1 -}}

                {{- end -}}
              {{- else -}}
                {{- $_ := set $return "errors" (append $return.errors (dict "file" $file.file "error" "Received empty ID" "trace" $incoming_wagon)) -}}
              {{- end -}}
            {{- end -}}
          {{- end -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}

    {{/* Conclude Train */}}
    {{- if $file_train -}}

      {{/* Run PostRenderers */}}
      {{- range $file := $file_train -}}
        {{- include "inventory.postrenders.func.execute" (dict "file" $file "extra_ctx" $file.data "extra_ctx_key" (include "inventory.render.defaults.files.data_key" $) "ctx" $.ctx) -}}
      {{- end -}}

      {{/* Post Manipulations */}}
      {{- range $file := $file_train -}}
        {{/* Add Checksum */}}
        {{- with $file.content -}}
          {{- $_ := set $file "checksum" (sha256sum (toYaml .)) -}}
        {{- end -}}
      {{- end -}}

      {{/* Collect all Errors */}}
      {{- range $id, $prop := $file_train -}}
        {{- $_ := set $return "errors" (concat $return.errors $prop.errors) -}}
      {{- end -}}

      {{/* Convert to Slice */}}
      {{- if not (kindIs "slice" $file_train) -}}
        {{- range $f, $c := $file_train -}}
          {{- $_ := set $return "files" (append $return.files $c) -}}
        {{- end -}}
      {{- else -}}
        {{- $_ := set $return "files" $file_train -}} 
      {{- end -}}

    {{- end -}}
    {{/* Return */}}
    {{- printf "%s" (toYaml $return) -}}
  {{- end -}}
{{- end -}}