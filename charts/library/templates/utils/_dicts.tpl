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
  Lookup <Template>
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
    {{- range $p := $paths -}}
      {{- $p = $p | replace "$" "." -}}
      {{- if (hasKey $buf $p) }}
        {{- if eq (last $paths) $p -}}
          {{- $_ := unset $buf $p -}}
        {{- else -}}
          {{- $buf = get $buf $p -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
  Set <Template>
*/}}
{{- define "lib.utils.dicts.set" -}}
  {{- if (kindIs "string" .path) -}}
    {{- $path := trimAll "." (default "" .path) -}}
    {{- if $path -}}
      {{- if $.data -}}
        {{- if $.value -}}
          {{- $buf := .data -}}
          {{- $paths := (splitList "." $path) -}}
          {{- range $p := $paths -}}
            {{- $p = $p | replace "$" "." -}}
            {{- if eq $p (last $paths) -}}
              {{- if (kindIs "map" $.value) -}}
                {{- include "lib.utils.dicts.merge" (dict "base" (get $buf $p) "data" $.value) -}}
              {{- else -}}
                {{- $_ := set $buf $p $.value -}}
              {{- end -}}
            {{- else -}}
              {{- if not (hasKey $buf $p) -}}
                {{- $_ := set $buf $p dict -}}
              {{- end -}}
              {{- $buf = get $buf $p -}}
            {{- end -}}
          {{- end -}}
        {{- end -}}
      {{- else -}}
      {{- $_ := set $ "data" dict -}}
        {{- $_ := set $ "data" "HELLLOOO" -}}
      {{- end -}}
    {{- end -}}
  {{- else -}}
    {{- fail (printf "$.path must be type string but is %s (%s)" (kindOf $.path) ($.path)) -}}
  {{- end -}}
{{- end -}}



{{/*
  Merge <Template>
*/}}
{{- define "lib.utils.dicts.merge" -}}
  {{/* Check if Data present */}}
  {{- if $.data -}}
    {{/* Check if Base present */}}
    {{- if $.base -}}
   
      {{/* if types don't match the key is overwritten */}}
      {{- if (eq (kindOf $.data) (kindOf $.base)) -}}

        {{/* Compare Types (Map) */}}
        {{- if (kindIs "map" $.data) -}}

          {{/* Iterate over Key */}}
          {{- range $key, $data := $.data -}}
            {{/* Get Same Key in Base */}}
            {{- $base_data := (get $.base $key) -}}
            {{- if $base_data -}}

              {{/* Recursive Call */}}
              {{- include "lib.utils.dicts.merge" (dict "base" $base_data "data" $data "ctx" $.ctx) -}}

            {{- else -}}
              {{/* Overwrite Base */}}
              {{- set $.base $key $.data -}}
            {{- end -}}

          {{- end -}}

        {{/* Compare Types (Slice) */}}
        {{- else if (kindIs "slice" $.data) -}}

          {{/* List Merge Recursion */}}
          {{- include "lib.utils.lists.merge" (dict "base" $.base "data" $.data "ctx" $.ctx) -}}        

        {{/* Overwrite (Any other Type) */}}
        {{- else -}}

          {{/* Overwrite */}}
          {{- set $ "base" $.data -}}

        {{- end -}}
  
  
      {{- else -}}
        {{/* Overwrite */}}
        {{- set $ "base" $.data -}}

      {{- end -}}
    {{- else -}}
      {{- set $ "base" $.data -}}

    {{- end -}}
  {{- end -}}
{{- end -}}



{{/*
  Redirect <Internal Template>
    Format Data Before Redirecting 
*/}}
{{- define "lib.utils.dicts.merge.int.redirect" -}}
  {{- fail (printf "key: %s value: %s base: %s" (toYaml $.key) (toYaml $.value) (toYaml $.base)) -}}
  {{- if (kindIs "slice" $.data) -}}
    {{- $_ := set $ "data" (without $.data (include "lib.utils.dicts.merge.int.inject_key" $)) -}}
    {{- range $d := $.data -}}
      {{- $mk := include "lib.utils.dicts.merge.int.merge_key" $d -}}
      {{- if $mk -}}
        {{- $_ := set $ "data" (without $.data $mk) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- $_ := set $.base $.key $.data -}}
{{- end -}}

{{/*
  Merge Key <Internal Template>
*/}}
{{- define "lib.utils.dicts.merge.int.merge_key" -}}
  {{/* Regex for Lookup */}}
  {{- $merge_exp := regexFind "\\(\\(.*\\)\\)" $ -}}
  {{- if $merge_exp -}}
    {{- printf "%s" ($merge_exp) -}}
  {{- end -}}
{{- end -}}
