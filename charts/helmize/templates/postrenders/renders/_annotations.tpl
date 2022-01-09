{{/* Annotations PostRenderer <Template> 

  Adds given annotations for component and annotations from values.

*/}}
{{- define "inventory.postrenders.renders.annotations" -}}
  {{- $return := dict "content" $.content "errors" list -}}
  {{- if $return.content.metadata -}}
    {{- if $.ctx.Values.annotations -}}
      {{- $_ := set $return.content.metadata "annotations" (mergeOverwrite (default dict $return.content.metadata.annotations) $.ctx.Values.annotations) -}}
    {{- end -}}
    {{- if $.Data.annotations -}}
      {{- $_ := set $return.content.metadata "annotations" (mergeOverwrite (default dict $return.content.metadata.annotations) $.Data.annotations) -}}
    {{- end -}}
  {{- end -}}
  {{- printf "%s" (toYaml $return) -}}
{{- end -}}