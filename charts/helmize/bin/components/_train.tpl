{{/*

  Gathers all relevant files based on given paths, extensions and exclusions and returns the paths

  params <dict>: 
    paths: <strict> Paths to look for files
    ctx: <dict> Global Context

  returns <dict>:
    files <dict>: contains all files
    errors <int>: amount of errors during file collection
    
*/}}
{{- define "inventory.components.train" -}}
  {{- if and $.cpt $.files $.ctx -}}
    {{- $return := dict "files" dict "errors" list -}}
    {{- $file_train := dict -}}
    {{- $file_counter := 0 -}}
    {{- $component_errors := 0 -}}
    {{- range $.files -}}
      {{- $file := fromYaml (include "inventory.components.parse" (dict "file" . "cpt" $.cpt "groups" $.groups "ctx" $.ctx)) }}
      {{- if (not (include "inventory.helpers.unmarshalingError" $file)) -}}
     
         {{- $id := $file.identifier -}}
         {{- $wagon := (get $file_train $id) -}}
         {{- if $wagon -}}
           {{- $_ := set $wagon "files" (concat $wagon.files $file.files) -}}
           {{- if $file.errors -}}
             {{- $_ := set $wagon "errors" (concat $wagon.errors $file.errors) -}}
             {{- $component_errors = addf $component_errors 1 -}}
           {{- else -}}
             {{- if $file.content -}}
               {{- $content_buff := (mergeOverwrite $wagon.content $file.content) -}}
               {{- $_ := set $wagon "content" $content_buff -}}
             {{- end -}}  
           {{- end -}}
           {{- $_ := set $file_train $id $wagon -}}
         {{- else -}}
           {{- $_ := set $file_train $id $file -}}
         {{- end -}}

      {{- else -}}

      {{- end -}}
    {{- end -}}
    {{/* Conclude Train */}}
    {{- range $id, $prop := $file_train -}}
      {{- $_ := set $return "errors" (concat $return.errors $prop.errors) -}}
    {{- end -}}
    {{- $_ := set $return "files" $file_train -}}
    {{- printf "%s" (toYaml $return) -}}
  {{- end -}}
{{- end -}}