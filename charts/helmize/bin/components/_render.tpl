{{- define "inventory.components.render" -}}
  {{- if and $.cpts $.ctx -}}
    {{- $cpts_raw := include "inventory.components.collect" (dict "cpts" $.cpts "groups" $.groups "ctx" $.ctx) -}}
    {{- $cpts := fromYaml ($cpts_raw) -}}
    {{- if (not (include "inventory.helpers.unmarshalingError" $cpts)) -}}
      {{- printf "%s" (toYaml $cpts) -}}
    {{- else -}}
      {{- include "inventory.helpers.fail" (printf "Missin Required Objects $.cpts ort $.ctx, got:\n%s" (toYaml $ | nindent 0)) -}}
    {{- end -}}  
  {{- else -}}
    {{- include "inventory.helpers.fail" (printf "Missin Required Objects $.cpts ort $.ctx, got:\n%s" (toYaml $ | nindent 0)) -}}
  {{- end -}}
{{- end -}}