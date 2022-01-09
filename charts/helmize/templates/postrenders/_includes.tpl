{{/* Includes <Template>
  
  Define which templates to run as postrenders
  Each new line in this template is parsed as a new postrenderer.

*/}}
{{- define "inventory.postrenders.includes" -}}
{{- include "inventory.postrenders.defaults.renders" $ -}}
{{- end -}}