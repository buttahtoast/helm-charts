

{{- define "inventory.entrypoint.templates.render" -}}
  {{- if $.deploy.files -}}
    {{- range $file, $prop := $.deploy.files -}}
      {{- if $prop.content -}}
        {{- printf "---\n# File: %s\n# Checksum %s\n%s\n" .id $prop.checksum (toYaml $prop.content) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}} 
{{- end -}}