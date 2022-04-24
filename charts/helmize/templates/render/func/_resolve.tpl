{{/* Resolve <Template> 

  Resolve the entire render structure

  params <dict>: Global Context

  returns <dict>:
    conditions <slice>: All applied conditions
    files <slice>: contains all files
    errors <int>: amount of errors during file collection
    
*/}}
{{- define "inventory.render.func.resolve" -}}

    {{/* Variables */}}
    {{- $ctx := $ -}}
    {{- $return := dict "files" list "errors" list "timestamps" list -}}

    {{/* Fetch Conditions */}}
    {{- $conds := fromYaml (include "inventory.conditions.func.resolve" (dict "ctx" $ctx)) -}}
    {{- if (not (include "lib.utils.errors.unmarshalingError" $conds)) -}}

      {{/* Error Redirect */}}
      {{- if $conds.errors -}}
        {{- $_ := set $return "errors" (concat $return.errors $conds.errors) -}}
      {{- end -}}

      {{/* Debug */}}
      {{- if (include "inventory.entrypoint.func.debug" $.ctx) -}}
        {{- $_ := set $return "conditions" $conds.conditions -}}
      {{- end -}}
      
      {{/* Iterate over each condition to get paths for file lookups */}}
      {{- $paths := list -}}
      {{- range $conds.conditions -}}
        {{- if .paths -}}
          {{- $paths = concat $paths .paths -}}
        {{- end -}}
      {{- end -}}

      {{/* Benchmark */}}
      {{- include "inventory.helpers.ts" (dict "msg" "Conditions initialized" "ctx" $return) -}}

      {{/* Only Lookup files if any path is present */}}
      {{- if $paths -}}

        {{/* Lookup actual files in the given paths */}}
        {{- $func_files := (dict "tpl" "inventory.render.func.files.finder" "ctx" (dict "paths" $paths "ctx" $ctx)) -}}
        {{- $files := (fromYaml (include $func_files.tpl $func_files.ctx)) -}}
          {{- if (not (include "lib.utils.errors.unmarshalingError" $files)) -}}
            
            {{/* Error Redirect */}}
            {{- with $files.errors -}}
              {{- $_ := set $return "errors" (concat $return.errors .) -}}
            {{- end -}}

            {{/* If any files were found */}}
            {{- if $files.files -}}

              {{/* Debug */}}
              {{- if (include "inventory.entrypoint.func.debug" $ctx) -}}
                {{- $_ := set $return "paths" $files.files -}}
              {{- end -}} 

              {{/* Benchmark */}}
              {{- include "inventory.helpers.ts" (dict "msg" "Files initialized" "ctx" $return) -}}

              {{/* Execute File Train */}}
              {{- $train := fromYaml (include "inventory.render.func.train" (dict "files" $files.files "groups" $.groups "ctx" $ctx "ts" $return)) -}}

              {{/* Benchmark */}}
              {{- include "inventory.helpers.ts" (dict "msg" "Train initialized" "ctx" $return) -}}

              {{- if (not (include "lib.utils.errors.unmarshalingError" $train)) -}}
                
                {{/* Error Redirect */}}
                {{- with $train.errors -}}
                  {{- $_ := set $return "errors" (concat $return.errors $train.errors) -}}
                {{- end -}}
               {{/* Files Redirect */}}
                {{- with $train.files -}}
                  {{- $_ := set $return "files" . -}}
                {{- end -}}
              {{- end -}}
            {{- end -}}  
          {{- else -}}
            {{- include "lib.utils.errors.fail" (printf "inventory.render.func.files.finder Returned invalid YAML:\n%s" (toYaml $func_files | nindent 2)) -}}
          {{- end -}}    
      {{- end -}}
    {{- end -}}

    {{/* Return */}}
    {{- printf "%s" (toYaml $return) -}}

{{- end -}}