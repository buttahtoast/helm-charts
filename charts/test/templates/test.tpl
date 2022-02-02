{{- $yaml_del := "\n---\n" -}}
{{- $data := $.Files.Get "data2.yaml" -}}
{{- $multi_yaml := splitList $yaml_del $data -}}

{{- range $multi_yaml -}}
t: | {{- toYaml . | nindent 2 }}
{{- end -}}