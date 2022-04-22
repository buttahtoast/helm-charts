{{/* GET POSTRENEDERS */}}
{{- define "inventory.postrenders.func.get" -}}
  {{- $return := (dict "renders" list) -}}
  {{- $cfg_renders := (fromYaml (include "inventory.config.func.resolve" (dict "path" (include "inventory.postrenders.defaults.cfg.post_renderers" $) "ctx" $.ctx))).res -}}
  {{- if $cfg_renders -}}
    {{- range $r := $cfg_renders -}}

      {{/* Inject Default Renderers */}}
      {{- if (eq $r (include "inventory.postrenders.defaults.cfg.post_renderers.inject_key" $)) -}}
        {{- $_ := set $return "renders" (concat $return.renders (fromYaml (include "inventory.postrenders.defaults.renders" $.ctx)).renders) -}}
      {{- else -}}
        {{- $_ := set $return "renders" (append $return.renders $r) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- printf "%s" (toYaml $return) -}}
{{- end -}}  