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
    {{- $return := dict "files" list "errors" list -}}

    {{/* Variables */}}
    {{- $file_train := dict -}}
    {{- $file_counter := 0 -}}
    {{/* Shared Data Over All Files */}}
    {{- $shared_data := dict -}}

    {{/* Iterate over files */}}
    {{- range $file := $.files -}}
      {{- $train_file := dict "files" (list $file) "errors" list "debug" list -}}

      {{/* Resolve Dropins for current path */}}
      {{- $dropins_data := dict -}}
      {{- $dropins := fromYaml (include "inventory.dropins.func.resolve" (dict "path" $file.file "ctx" $.ctx)) -}}
      {{- if (not (include "lib.utils.errors.unmarshalingError" $dropins)) -}}
            
        {{/* Dropins without errors */}}
        {{- $_ := set $train_file "dropins" (omit $dropins "errors") -}}

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
      {{- $dropins_data = mergeOverwrite $dropins_data $shared_data -}}

      {{/* Parse file(s) */}}
      {{- $train_file_contents_raw := include "inventory.render.func.files.parse" (dict "parse" ($file) "extra_ctx" $dropins_data "extra_ctx_key" "Data" "shared_data" $shared_data "ctx" $.ctx) -}}
      {{- $train_file_contents := fromYaml ($train_file_contents_raw) -}}
      {{- if (not (include "lib.utils.errors.unmarshalingError" $train_file_contents)) -}}

        {{/* Foreach resolved file */}}
        {{- range $c := $train_file_contents.files -}}

          {{/* Merge with Metadata */}}
          {{- $incoming_wagon := mergeOverwrite $train_file (omit $c "errors") | deepCopy -}}
 
          {{/* Parse Content, if not map */}}
          {{- if not (kindIs "map" $incoming_wagon.content) -}}
            {{- $_ := set $incoming_wagon "content" (fromYaml ($incoming_wagon.content)) -}}
          {{- end -}}          


          {{/* Persist Identifier */}}
          {{- $id := $incoming_wagon.id -}}

          {{/* PreCheck ID */}}
          {{- if $id -}}
  
            {{/* Check if any file with the same identifier is already present */}}
            {{- $wagon := (get $file_train $id) -}}
            {{- if $wagon -}}
  
              {{/* Merge file Properties */}}
              {{- with $incoming_wagon.files -}}
                {{- $_ := set $wagon "files" (concat $wagon.files $incoming_wagon.files) -}}
              {{- end -}}  
  
              {{/* Merge Errors */}}
              {{- if $incoming_wagon.errors -}}
                {{- $_ := set $wagon "errors" (concat $wagon.errors $incoming_wagon.errors) -}}
              {{- else -}}
                {{/* Merge Contents */}}
                {{- if $incoming_wagon.content -}}
                  {{- $_ := set $wagon "content" (mergeOverwrite (default dict $wagon.content) $incoming_wagon.content) -}}
                {{- end -}}  
              {{- end -}}
  
              {{/* Update Wagon */}}
              {{- $_ := set $file_train $id $wagon -}}
  
            {{- else -}}
  
              {{/* Add File as new file */}}
              {{- $_ := set $file_train $id $incoming_wagon -}}
  
            {{- end -}}
          {{- else -}}
            {{/* Error on Empty ID */}}
          
          {{- end -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}


    {{- $_ := set $return "OUTER" $file_train -}}

    {{/* Conclude Train */}}
    {{- if $file_train -}}

      {{/* Run PostRenderers */}}
      {{- range $file := $file_train -}}
        {{- $post_renders := (fromYaml (include "inventory.postrenders.func.execute" (dict "file" $file "extra_ctx" $file.dropins.data "extra_ctx_key" "Data" "ctx" $.ctx) )) -}}
        {{- if (not (include "lib.utils.errors.unmarshalingError" $post_renders)) -}}

          {{/* Redirect Error */}}
          {{- if $post_renders.errors -}}
            {{- $_ := set $return "errors" (concat $return.errors $post_renders.errors) -}}
          {{- end -}}

          {{/* Redirect Content */}}
          {{- with $post_renders.content -}}
            {{- $_ := set $file "content" . -}}
          {{- end -}}
        {{- end -}}
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