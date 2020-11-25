{{/*
  Everything in here is not considered Stable and shouldn't be used!
*/}}


{{- define "stringPath" -}}
  {{- if and .path .dictionary -}}
    {{- $path := splitList "." (.path | trimAll "." ) -}}
    {{- $dictionary := .dictionary -}}
    {{- if $path -}}
      {{- range $path -}}
        {{- $l_path := . }}
        {{- if (kindIs "slice" $dictionary) }}
          {{- $l_dictionary := list }}
          {{- range $dictionary }}
            {{- if (hasKey . $l_path) }}
              {{- $l_dictionary = append $l_dictionary (get . $l_path) }}
            {{- end }}
          {{- end }}
          {{- if $l_dictionary }}
            {{- $dictionary = $l_dictionary }}
          {{- end }}
        {{- else }}
          {{- if (hasKey $dictionary .) -}}
            {{- $dictionary = get $dictionary . -}}
          {{- end -}}
        {{- end }}
      {{- end -}}
      {{- toYaml $dictionary }}
    {{- else -}}
      {{- toYaml $dictionary }}
    {{- end -}}
  {{- end -}}
{{- end -}}
