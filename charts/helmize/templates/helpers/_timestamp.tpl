{{- define "inventory.helpers.ts" -}}
   {{- $_ := set $.ctx "timestamps" (append $.ctx.timestamps (dict "point" $.msg "time" now)) -}}
{{- end -}}