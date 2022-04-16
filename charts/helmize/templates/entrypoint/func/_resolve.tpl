{{/* Resolve <Template> 

  Entrypoint to resolve Render Data
  
  params <dict>: Global Context

*/}}
{{- define "inventory.entrypoint.func.resolve" -}}
    {{- $render_raw := include "inventory.render.func.resolve" $ -}}
    {{- $render := fromYaml ($render_raw) -}}
    {{- if (not (include "lib.utils.errors.unmarshalingError" $render)) -}}
      {{/* Return */}}
      {{- printf "%s" (toYaml $render) -}}
    {{- else -}}
      {{- include "lib.utils.errors.fail" (printf "Render template returned invalid YAML:%s" (toYaml $render_raw | nindent 2)) -}}
    {{- end -}}
{{- end -}}