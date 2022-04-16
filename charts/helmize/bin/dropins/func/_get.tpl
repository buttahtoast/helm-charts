{{/* Get <Template>

  Get Configured Dropins and validate against type

  params <dict> content: Global context

  returns <dict>:
    dropins: <list> Valid Dropins
    errors: <list> Errors encoutered during templating

*/}}
{{- define "inventory.dropins.func.get" -}}
  {{- $return :=  dict "dropins" list "errors" list -}}

  {{/* Get Dropins from config */}}
  {{- $dropins := (fromYaml (include "inventory.config.func.resolve" (dict "path" (include "inventory.dropins.defaults.dropins" $) "ctx" $))).res -}}
  {{- if $dropins -}}
    {{- range $drop := $dropins -}}

      {{/* Validate each Dropin */}}
      {{- $dropin := fromYaml (include "lib.utils.types.validate" (dict "type" "inventory.dropins.types.dropin" "data" . "ctx" $)) -}}

      {{/* Check if Type is valid */}}
      {{- if $dropin.isType -}}
        {{- $_ := set $return "dropins" (append $return.dropins $drop) -}}
      {{- else -}}
        {{/* Error Redirect */}}
        {{- $_ := set $return "errors" (append $return.errors (dict "error" "Dropin has type errors" "type_errors" $dropin.errors)) -}}
      {{- end -}}

    {{- end -}}
  {{- end -}}

  {{/* Return */}}
  {{- printf "%s" (toYaml $return) -}}

{{- end -}}