{{/* Get <Template>

  Collect Render Manifest

  params <dict>: Global Context
  returns <dict>:
    files <slice>: All Files to be deployed
    errors <slice>: All Errors
 
*/}}
{{- define "inventory.render.func.get" -}}
  {{/* Collect Render */}}
  {{- $render_raw := include "inventory.render.func.resolve" $ -}}
  {{- $render := fromYaml ($render_raw) -}}
  {{- if (not (include "lib.utils.errors.unmarshalingError" $render)) -}}
    {{- printf "%s" (toYaml $render) -}}
  {{- else -}}
    {{- include "lib.utils.errors.fail" (printf "Render Returned invalid YAML:\n%s" (toYaml $render_raw | nindent 2)) -}}
  {{- end -}}
{{- end -}}