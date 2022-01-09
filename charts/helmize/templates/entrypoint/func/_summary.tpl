{{/* Summary <Template> 

  Returns the summary as YAML so you can further modify it and use it for your needs.
  
  params <dict>: Global Context

*/}}
{{- define "inventory.entrypoint.func.summary" -}}

  {{/* Resolve Files */}}
  {{- $deploy_raw := include "inventory.entrypoint.func.resolve" $ -}}
  {{- $deploy := fromYaml ($deploy_raw) -}}
  {{- if (not (include "lib.utils.errors.unmarshalingError" $deploy)) -}}
    {{- printf "%s" (toYaml $deploy) -}} 
  {{- else -}}
    {{- include "lib.utils.errors.fail" (printf "Render did not return valid YAML:\n%s" ($deploy_raw | nindent 2)) -}}
  {{- end -}}

{{- end -}}