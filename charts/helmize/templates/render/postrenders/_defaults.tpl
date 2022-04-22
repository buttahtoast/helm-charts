{{/* Defaults <Template> 

  Default Render Templates

*/}}
{{- define "inventory.postrenders.defaults.cfg.post_renderers" -}}
post_renderers
{{- end -}}


{{- define "inventory.postrenders.defaults.cfg.post_renderers.inject_key" -}}
inject_defaults
{{- end -}}

{{/* Default Renders <Template> 
  Returns the default render templates
*/}}
{{- define "inventory.postrenders.defaults.renders" -}}
renders:
  - "inventory.postrenders.renders.labels"
  - "inventory.postrenders.renders.annotations"
{{- end -}}
