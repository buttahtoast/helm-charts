{{/*
  ParentAppend <Template>
*/}}
{{- define "lib.utils.dicts.parentAppend" -}}
  {{- $baseDict := dict -}}
  {{- $_ := set $baseDict (default .key "Values") (default . .append) -}}
  {{- toYaml $_ | indent 0 }}
{{- end -}}


{{/*
  PrintYamlStructure <Template>
*/}}
{{- define "lib.utils.dicts.printYAMLStructure" -}}
  {{- if .structure }}
    {{ $structure := trimAll "." .structure }}
    {{- $i := 0 }}
    {{- if $structure }}
      {{- range (splitList "." $structure) }}
        {{- . | nindent (int $i) }}:
        {{- $i = add $i 2 }}
      {{- end }}
    {{- end }}
    {{- if .data }}
      {{- .data | nindent (int $i) }}
    {{- end }}
  {{- end }}
{{- end -}}

{{/*
  Get <Template>
*/}}
{{- define "lib.utils.dicts.get" -}}
  {{- $result := dict "res" dict -}}
  {{- $path := trimAll "." .path -}}
  {{- if and $path .data -}}
    {{- $buf := .data -}}
    {{- $miss := dict "state" false "path" -}}
    {{- range $p := (splitList "." $path) -}}
      {{- $p = $p | replace "$" "." -}}
      {{- if eq $miss.state false -}}
        {{- if (hasKey $buf $p) -}}
          {{- $buf = get $buf $p -}}
        {{- else -}}
          {{- $_ := set $miss "path" $p -}}
          {{- $_ := set $miss "state" true -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
    {{- if eq $miss.state false -}}
      {{- printf "%s" (toYaml (dict "res" $buf)) -}}
    {{- else -}}
      {{- if eq (default false .required) true -}}
        {{ include "lib.utils.errors.fail" (cat "Missing path" $miss.path "for get" $path "in structure\n" (toYaml .data | nindent 0)) }}
      {{- else -}}
        {{- printf "%s" (toYaml $result) -}}
      {{- end -}}
    {{- end -}}
  {{- else -}}
    {{- printf "%s" (toYaml $result) -}}
  {{- end -}}
{{- end -}}


{{/*
  Unset <Template>
*/}}
{{- define "lib.utils.dicts.unset" -}}
  {{- $path := trimAll "." $.path -}}
  {{- if and $path $.data -}}
    {{- $buf := $.data -}}
    {{- $paths := (splitList "." $path) -}}
    {{- range $i, $p := $paths -}}
        {{- if (hasKey $buf .) }}
          {{- if eq (last $paths) . -}}
            {{- $_ := unset $buf . -}}
          {{- else -}}
            {{- $buf = get $buf . -}}
          {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
  Set <Template>
*/}}
{{- define "lib.utils.dicts.set" -}}
  {{- $path := trimAll "." .path -}}
  {{- if and $path $.data $.value -}}
    {{- $buf := .data -}}
    {{- $paths := (splitList "." $path) -}}
    {{- range $paths }}
      {{- if eq . (last $paths) -}}
        {{- $_ := set $buf . $.value -}}
      {{- else -}}
        {{- if not (hasKey $buf .) }}
          {{- $_ := set $buf . dict -}}
        {{- end -}}
        {{- $buf = get $buf . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

