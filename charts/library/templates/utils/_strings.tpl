{{/*

Copyright © 2021 Buttahtoast

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

*/}}
{{/*
  Sprig Template - Template
*/}}
{{- define "lib.utils.strings.template" -}}
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
{{- define "lib.utils.strings.stringify" -}}
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
{{- define "lib.utils.strings.toDns1123" -}}
  {{- if (kindIs "string" .) }}
    {{- printf "%s" (regexReplaceAll "[^a-z0-9-.]" (lower .) "${1}-") | trunc 63 | trimSuffix "-" | trimPrefix "-" }}
  {{- else }}
    {{- . }}
  {{- end }}
{{- end }}
