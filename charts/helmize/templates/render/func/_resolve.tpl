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
    {{- $return := dict "files" list "errors" list -}}

    {{/* Fetch Conditions */}}
    {{- $conds := fromYaml (include "inventory.conditions.func.resolve" (dict "ctx" $ctx)) -}}
    {{- if (not (include "lib.utils.errors.unmarshalingError" $conds)) -}}

      {{/* Error Redirect */}}
      {{- if $conds.errors -}}
        {{- $_ := set $return "errors" (concat $return.errors $conds.errors) -}}
      {{- end -}}

      {{/* Debug */}}
      {{- $_ := set $return "conditions" $conds.conditions -}}

      {{/* Iterate over each condition to get paths for file lookups */}}
      {{- $paths := list -}}
      {{- range $conds.conditions -}}
        {{- if .paths -}}
          {{- $paths = concat $paths .paths -}}
        {{- end -}}
      {{- end -}}

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
              {{- $_ := set $return "paths" $files.files -}}

              {{/* Execute File Train */}}
              {{- $train := fromYaml (include "inventory.render.func.train" (dict "files" $files.files "groups" $.groups "ctx" $ctx)) -}}

              {{/* DEBUG */}}
              {{- $_ := set $return "debug" $train -}}

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

    {{/* Errors are duplicated. Therefor we evaluate which are unique based on checksums (Improvement on refactor pls) */}}
    {{- $errs := list -}}
    {{- $err_checksums := list -}}
    {{- range $err := $return.errors -}}
       {{- $check := (toYaml $err | sha1sum) -}}
       {{- if not (has $check $err_checksums) -}}
         {{- $err_checksums = append $err_checksums $check -}}
         {{- $errs = append $errs $err -}}
       {{- end -}}
    {{- end -}}
    {{- $_ := set $return "errors" $errs -}}

    {{/* Return */}}
    {{- printf "%s" (toYaml $return) -}}

{{- end -}}