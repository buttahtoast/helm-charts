{{/* Labels PostRenderer <Template> 

  Adds given Labels for component and labels from values.

*/}}
{{- define "inventory.postrenders.renders.labels" -}}
  {{- if $.content -}}
    {{- if $.content.metadata -}}
      {{- if $.ctx.Values.labels -}}
        {{- $_ := set $.content.metadata "labels" (mergeOverwrite (default $.content.metadata.labels) $.ctx.Values.labels) -}}
      {{- end -}}
      {{- if $.Data.labels -}}
        {{- $_ := set $.content.metadata "labels" (mergeOverwrite (default $.content.metadata.labels) $.Data.labels) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- printf "%s" (toYaml $.content) -}}
{{- end -}}
