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

    {{- $_ := set $return "empty" (dict "meow" "me") -}}

    {{/* Variables */}}
    {{- $file_train := dict -}}
    {{- $file_counter := 0 -}}

    {{/* Iterate over files */}}
    {{- range $file := $.files -}}
      {{- $train_file := dict "files" (list $file) "errors" list -}}

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


      {{/* Parse file(s) */}}
      {{- $train_file_contents_raw := include "inventory.render.func.files.parse" (dict "parse" ($file) "extra_ctx" $dropins_data "extra_ctx_key" "Data" "ctx" $.ctx) -}}
      {{- $train_file_contents := fromYaml ($train_file_contents_raw) -}}
      {{- if (not (include "lib.utils.errors.unmarshalingError" $train_file_contents)) -}}

        {{- $_ := set $return "DEBUG" (append (default list $return.DEBUG) (dict "raw" $train_file_contents_raw "parsed" $train_file_contents)) -}}
      
        
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

        {{- else -}}

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