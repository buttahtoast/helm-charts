{{/* Get <Template>

  Get Configured Conditions and validate against type

  params <dict> content: Global context

  returns <dict>:
    conditions: <list> Valid Conditions
    errors: <list> Errors encoutered during templating

*/}}
{{- define "inventory.conditions.func.get" -}}
  {{- $return :=  dict "conditions" list "errors" list -}}

  {{/* Get Conditions from config */}}
  {{- $conditions := (fromYaml (include "inventory.config.func.resolve" (dict "path" (include "inventory.conditions.defaults.conditions" $) "ctx" $))).res -}}
  {{- if $conditions -}}
    {{- $check_names := list -}}
    {{- range $cond := $conditions -}}

      {{/* Validate each Condition */}}
      {{- $validate_cond := fromYaml (include "lib.utils.types.validate" (dict "type" "inventory.conditions.types.condition" "data" . "ctx" $)) -}}

      {{/* Check if Type is valid */}}
      {{- if $validate_cond.isType -}}
 
        {{/* Additional Checks */}}
        {{- $errs := list -}}

        {{/* Avoid Duplicated Names */}}
        {{- if (has $cond.name $check_names) -}}
          {{- $errs = append $errs (dict "error" (printf "Condition name '%s' was declared multiple times. Names must be unique!" $cond.name) "condition" .name) -}}
        {{- else -}}
          {{- $check_names = append $check_names $cond.name -}}
        {{- end -}}

        {{/* Check State */}}
        {{- if $errs -}}
          {{- $_ := set $return "errors" (concat $return.errors $errs) -}}
        {{- else -}}
          {{- $_ := set $return "conditions" (append $return.conditions $cond) -}}
        {{- end -}}
      {{- else -}}
        {{/* Error Redirect */}}
        {{- $_ := set $return "errors" (append $return.errors (dict "error" "Condition has type errors" "type_errors" $validate_cond.errors)) -}}
      {{- end -}}

    {{- end -}}
  {{- end -}}

  {{/* Return */}}
  {{- printf "%s" (toYaml $return) -}}

{{- end -}}