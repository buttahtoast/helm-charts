{{/* Resolve <Template> 

  Returns all possible paths considered all the given conditions

  params <dict>:
    ctx <dict> Required: Global Context
  returns <dict>:
    conditions <slice>: All Conditions with their valid paths
    errors <slice>: Errors during condition validation

*/}}
{{- define "inventory.conditions.func.resolve" -}}
  {{- $return :=  dict "conditions" list "errors" list -}}
  {{- if $.ctx -}}
 
    {{/* Get All Conditions */}}
    {{- $conditions := fromYaml (include "inventory.conditions.func.get" $.ctx) -}}
  
    {{/* Evaluate each condition */}}
    {{- if $conditions -}}

      {{/* Error Redirect */}}
      {{- with $conditions.errors -}}
        {{- $_ := set $return "errors" (concat $return.errors .) -}}
      {{- end -}}

      {{/* Iterate over Conditions */}}
      {{- range $conditions.conditions -}}
  
          {{/* Condition Variables */}}
          {{- $condition := . -}}
          {{- $condition_path := default .name .path -}}
          {{- $condition_keys := list -}}
          {{- $condition_struct := dict "name" $condition.name "root_path" $condition_path "paths" list "keys" list "config" $condition -}}
  
          {{/* Add Condition Keys */}}
          {{- $key := (fromYaml (include "lib.utils.dicts.lookup" (dict "data" $.ctx "path" (default "" $condition.key) "required" false))).res }}
          {{- if and $condition.key (and (not $key) ($condition.required)) -}}
            {{- include "inventory.helpers.fail" (printf "A Value for %s is required but not set" $condition.key) -}}
          {{- else if not $key -}}
            {{- if $condition.default -}}
              {{- $condition_keys = append $condition_keys .default -}}
            {{- end -}}
          {{- else -}}
            {{- if (kindIs "slice" $key) -}}
              {{- $condition_keys = concat $condition_keys $key -}}
            {{- else -}}
              {{- $condition_keys = append $condition_keys $key -}}
            {{- end -}}  
          {{- end -}}
  
          {{/* Add groups as possible keys */}}
          {{- if not $condition.groups_disabled -}}
            {{- if $.roles -}}
              {{- $condition_keys = concat $.roles $condition_keys -}}
            {{- end -}}
          {{- end -}}
  
          {{/* Apply a filter to all results */}}
          {{- if $condition.filter -}}
            {{- $filtered_list := $condition_keys -}}
            {{- if $condition.reverseFilter -}}
              {{- $filtered_list = list -}}
            {{- end -}}
            {{- if (kindIs "string" $condition.filter) -}}
              {{- $_ := set $condition "filter" (list $condition.filter) -}}
            {{- end -}}
            {{- range $condition_keys -}}
              {{- $con := . -}}
              {{- range $condition.filter -}}
                {{- if (regexMatch . $con) -}}
                  {{- if $condition.reverseFilter -}}
                    {{- $filtered_list = append $filtered_list $con -}}
                  {{- else -}}
                    {{- $filtered_list = without $filtered_list $con -}}
                  {{- end -}}
                {{- end -}}
              {{- end -}}
            {{- end -}}
            {{- $condition_keys = $filtered_list -}}
          {{- end -}}
  
          {{/* Create Path for each Condition Key */}}
          {{- $condition_keys = $condition_keys | uniq -}}
          {{- if $condition_keys -}}
            {{- $_ := set $condition_struct "keys" $condition_keys -}}
            {{- range $condition_keys -}}
              {{- $path := include "inventory.conditions.func.path" (dict "path" $condition_path "cond" . "cpt" $.cpt "ctx" $.ctx) -}}
              {{- $_ := set $condition_struct "paths" (append $condition_struct.paths $path) -}}
            {{- end -}}
          {{- end -}}
          {{- $_ := set $return "conditions" (append $return.conditions $condition_struct) -}}
  
      {{- end -}}
    {{- end -}}  
  
    {{/* Return */}}
    {{- printf "%s" (toYaml $return) -}}

  {{- else -}}
    {{- include "lib.utils.errors.params" (dict "tpl" "inventory.conditions.func.resolve" "params" (list "ctx")) -}}
  {{- end -}}
{{- end -}}