{{/*
  Sprig Template - Template
*/}}
{{- define "lib.utils.stings.template" -}}
  {{- if .context }}
    {{- $_ := set .context (default "extraVars" .extraValuesKey) (default dict .extraValues) }}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context  | replace "+|" "\n" }}
    {{- else }}
        {{- tpl (.value | toYaml) .context | replace "+|" "\n" }}
    {{- end }}
    {{- $_ := unset .context (default "extraVars" .extraValuesKey) }}
  {{- else }}
    {{- fail "Template requires '.context' as argument" }}
  {{- end }}
{{- end -}}


{{/*
  Sprig Template - Stringify
*/}}
{{- define "lib.utils.stings.stringify" -}}
  {{- if and .list .context }}
    {{- $delimiter := (default " " .delimiter) -}}
    {{- if kindIs "slice" .list }}
        {{- printf "%s" (include "lib.utils.strings.template" (dict "value" (.list | join $delimiter) "context" .context)) | indent 0 }}
    {{- end }}
  {{- else }}
    {{- fail "Template requires '.list' and '.context' as arguments" }}
  {{- end }}
{{- end }}


{{/*
  Sprig Template - ToDns1123
*/}}
{{- define "lib.utils.stings.toDns1123" -}}
  {{- if (kindIs "string" .) }}
    {{- printf "%s" (regexReplaceAll "[^a-z0-9-.]" (lower .) "${1}-") | trunc 63 | trimSuffix "-" | trimPrefix "-" }}
  {{- else }}
    {{- . }}
  {{- end }}
{{- end }}
