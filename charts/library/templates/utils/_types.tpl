{{/* 
  Validate <Template> 
*/}}
{{- define "lib.utils.types.validate" -}}
  {{- if and $.type $.ctx -}}
    {{- $return := dict "isType" 1 "errors" list -}}
    {{- $type_raw := include $.type $.ctx -}}
    {{- $type := fromYaml ($type_raw) -}}
    {{- if not (include "lib.utils.errors.unmarshalingError" $type) -}}
      {{- range $field, $prop := $type -}}

        {{/* Get Field */}}
        {{- $d_field := get $.data $field -}}


        {{/* Assign Default if not present */}}
        {{- if (ne (toString $d_field) "false") -}}
          {{- if and (not $d_field) ($prop.default) -}}
            {{- $d_field = $prop.default -}}
            {{- $_ := set $.data $field $prop.default -}}
          {{- end -}}
        {{- end -}}

        {{/* Validate */}}
        {{- if or $d_field (eq (toString $d_field) "false") -}}

          {{/* Values Comparison */}}
          {{- if $prop.values -}}

            {{/* Convert types to list */}}
            {{- if not (kindIs "slice" $prop.values) -}}
              {{- $_ := set $prop "values" (list $prop.values) -}}
            {{- end -}}

            {{/* Check for each kind */}}
            {{- $isValue := 0 -}}
            {{- range $prop.values -}}
              {{- if (eq (. | toString) ($d_field | toString)) -}}
                {{- $isValue = 1 -}}
              {{- end -}}
            {{- end -}}

            {{/* Check if Value was valid */}}
            {{- if not $isValue -}}
              {{- $_ := set $return "isType" 0 -}}
              {{- $_ := set $return "errors" (append $return.errors (dict "error" (printf "Field %s did not match any of these values: %s" $field ($prop.values | join ", ")))) -}}
            {{- end -}}

          {{- end -}}

  
          {{/* Type Comparison */}}
          {{- if $prop.types -}}
  
            {{/* Convert types to list */}}
            {{- if not (kindIs "slice" $prop.types) -}}
              {{- $_ := set $prop "types" (list $prop.types) -}}
            {{- end -}}
  
            {{/* Check for each kind */}}
            {{- $isKind := 0 -}}
            {{- range $prop.types -}}
              {{- if (kindIs . $d_field) -}}
                {{- $isKind = 1 -}}
              {{- end -}}
            {{- end -}}
  
            {{/* Check if Kind was valid */}}
            {{- if not $isKind -}}
              {{- $_ := set $return "isType" 0 -}}
              {{- $_ := set $return "errors" (append $return.errors (dict "error" (printf "Field %s did not match any of these types: %s" $field ($prop.types | join ", ")))) -}}
            {{- end -}}
  
          {{- end -}}
        {{- else -}}
  
          {{/* When field does not exist, check if it's required */}}
          {{- if $prop.required -}}
            {{- $_ := set $return "isType" 0 -}}
            {{- $_ := set $return "errors" (append $return.errors (dict "error" (printf "Field %s is required but not set" $field))) -}}
          {{- end -}}

        {{- end -}}
      {{- end -}}
    {{- else -}}
      {{- include "lib.utils.errors.fail" (printf "Type Template %s did not return valid YAML:\n%s" $.type ($type_raw | nindent 2)) -}}
    {{- end -}}  

    {{/* Return */}}
    {{- printf "%s" (toYaml $return) -}}

  {{- else -}}
    {{- include "lib.utils.errors.params" (dict "tpl" "lib.utils.types.validate" "params" (list "type" "data" "ctx")) -}}
  {{- end -}}
{{- end -}}