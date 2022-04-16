{{/* Annotations PostRenderer <Template> 

  Adds given annotations for component and annotations from values.

*/}}
{{- define "inventory.postrenders.renders.annotations" -}}
  {{- if $.content -}}
    {{- if $.content.metadata -}}
      {{- if $.ctx.Values.annotations -}}
        {{- $_ := set $.content.metadata "annotations" (mergeOverwrite (default dict $.content.metadata.annotations) $.ctx.Values.annotations) -}}
      {{- end -}}
      {{- if $.Data.annotations -}}
        {{- $_ := set $.content.metadata "annotations" (mergeOverwrite (default dict $.content.metadata.annotations) $.Data.annotations) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- printf "%s" (toYaml $.content) -}}
{{- end -}}