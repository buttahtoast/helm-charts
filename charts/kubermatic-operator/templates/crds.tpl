{{/* CustomResources Lifecycle */}}
{{- if $.Values.kubermaticOperator.crds.install }}
  {{ range $path, $_ :=  .Files.Glob "crd/**" }}
    {{- with $ }}
      {{- $content := (tpl (.Files.Get $path) .) -}}
      {{- $p := (fromYaml $content) -}}

      {{/* Add Common Lables */}}
      {{- $_ := set $p.metadata "labels" (mergeOverwrite (default dict (get $p.metadata "labels")) (fromYaml (include "helm.labels" $))) -}}

      {{/* Add Keep annotation to CRDs */}}
      {{- if $.Values.kubermaticOperator.crds.keep }}
        {{- $_ := set $p.metadata.annotations "helm.sh/resource-policy" "keep" -}}
      {{- end }}

      {{- if $p }}
        {{- printf "---\n%s" (toYaml $p) | nindent 0 }}
      {{- end }}
    {{ end }}
  {{- end }}
{{- end }}
