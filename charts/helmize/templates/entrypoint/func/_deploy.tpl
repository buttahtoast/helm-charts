{{/* Deploy <Template> 

  Returns deployable kubernetes manifests. If any errors are found the template errrors

  params <dict>: Global Context

*/}}
{{- define "inventory.entrypoint.func.deploy" -}}

  {{/* Resolve Files */}}
  {{- $deploy_raw := include "inventory.entrypoint.func.resolve" $ -}}
  t: | {{ $deploy_raw | nindent 10 }}
  {{- $deploy := fromYaml ($deploy_raw) -}}
  {{- if (not (include "lib.utils.errors.unmarshalingError" $deploy)) -}}

    {{/* Validate Force Function */}}
    {{- $force := ((fromYaml (include "inventory.config.func.resolve" (dict "path" (include "inventory.entrypoint.defaults.force" $) "ctx" $))).res) -}}
   
    {{/* Check if Errors were found */}}
    {{- if or (not $deploy.errors) (and ($deploy.errors) ($force)) -}}

      {{/* Iterate Over Files */}}
      {{- range $file, $prop := $deploy.files -}}
        {{- if $prop.content -}}
          {{- printf "---\n# File: %s\n# Checksum %s\n%s\n" .identifier $prop.checksum (toYaml $prop.content) -}}
        {{- end -}}      
      {{- end -}}  

    {{- else -}}
      {{- include "lib.utils.errors.fail" (printf "Found errors in render manifest, please resolve those errors or use the force options:\n%s" (toYaml $deploy.errors | nindent 2)) -}}
    {{- end -}}
  {{- else -}}
    {{- include "lib.utils.errors.fail" (printf "Render did not return valid YAML:\n%s" ($deploy_raw | nindent 2)) -}}
  {{- end -}}
{{- end -}}  