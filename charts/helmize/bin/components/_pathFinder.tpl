{{/*

  Gathers all relevant files based on given paths, extensions and exclusions and returns the paths

  params <dict>: 
    paths: <strict> Paths to look for files
    ctx: <dict> Global Context

  returns <dict>:
    files: <slice> Found files

*/}}
{{- define "inventory.components.pathFinder" -}}
  {{- if and $.paths $.ctx -}}
    {{- $return := dict "files" list "errors" list -}}

    {{/* Get allowed file extensions */}}
    {{- $extensions := (fromYaml (include "inventory.config.resolve" (dict "path" "file.extensions" "ctx" $.ctx))).res -}}
    {{- if $extensions -}}
      {{- if not (kindIs "slice" $extensions) -}}
        {{- $extensions = list  ($extensions | toString) -}}
      {{- end -}}
    {{- else -}}
      {{- $extensions = list ".yaml" ".yml" ".tpl" -}}
    {{- end -}}

    {{/* Get Excluded Files */}}
    {{- $excludes := (fromYaml (include "inventory.config.resolve" (dict "path" "file.excludes" "ctx" $.ctx))).res -}} 
    {{- if $excludes -}}
      {{- if not (kindIs "slice" $excludes) -}}
        {{- $excludes = list  ($excludes | toString) -}}
      {{- end -}}
    {{- end -}}  

    {{/* Iterate for each Path */}}
    {{- range $.paths -}}
      {{- $p_path := . -}}
      {{- $p_files := list -}}
      {{ range $file, $_ :=  $.ctx.Files.Glob (include "inventory.components.pathFinder.search" (dict "path" $p_path "ext" .)) -}}
        {{- $valid := 1 -}}

        {{/* Validate for each extension, one must match */}}
        {{- if $extensions -}}
          {{- $match := 0 -}}
          {{- range $extensions -}}
            {{- if (hasSuffix . $file) -}}
              {{- $match = 1 -}}
            {{- end }}
          {{- end -}}
          {{- if not $match -}}
            {{- $valid = 0 -}}
          {{- end -}}
        {{- end -}}

        {{/* Validate for each exclusion, one must match */}}
        {{- if $excludes -}}
          {{- $exclusion := 1 -}}
          {{- range $excludes -}}
            {{- if (regexMatch . $file) -}}
              {{- $exclusion = 0 -}}
            {{- end }}
          {{- end -}}
          {{- if not $exclusion -}}
            {{- $valid = 0 -}}
          {{- end -}}
        {{- end -}}

        {{/* Add to files after correct validation */}}
        {{- if $valid -}}
          {{- $_ := set $return "files" (append $return.files (dict "file" $file "path" $p_path)) -}}
        {{- end -}}

      {{- end -}}
    {{- end -}}
    {{- printf "%s" (toYaml $return) -}}
  {{- end -}}
{{- end -}}


{{- define "inventory.components.pathFinder.search" -}}
  {{- $path := $.path | trimPrefix "./" | trimPrefix "/" -}}
  {{- printf "%s**" $path -}}
{{- end -}}