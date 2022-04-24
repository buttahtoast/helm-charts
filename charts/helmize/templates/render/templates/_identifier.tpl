{{/* Identifier Template <Template>

  This is the default Template used 

  params <dict>: 
    content: <dict> File Content
    id: <dict> File identifier
    ctx: Required <dict> Global Context

  returns <dict>:
    id: <slice> Evaluated identifier(s)
    allowEmptyIds: <bool> Tells the evaluating template if empty id values are allowed
    errors: <slice> Errors encoutered during parsing

*/}}
{{- define "inventory.render.templates.identifier" -}}

  {{/* File has content */}}
  {{- if $.wagon.content -}}
  
    {{/* Check if dedicated id field is set */}}
    {{- if $.wagon.content.id -}}
      {{- if (kindIs "slice" $.wagon.content.id) -}}
        {{- $_ := set $.wagon "id" (concat $.wagon.id $.wagon.content.id) -}}
      {{- else -}}
        {{- $_ := set $.wagon "id" (append $.wagon.id $.wagon.content.id) -}}
      {{- end -}}
      {{- $_ := unset $.wagon.content "id" -}}
    {{- end -}}

    {{/* kind-name identifier */}}
    {{- if $.wagon.content.kind -}}
      {{- with $.wagon.content.metadata -}}
        {{- if .name -}}
          {{- $_ := set $.wagon "id" (append $.wagon.id (printf "%s-%s.yaml" ($.wagon.content.kind | lower) ($.wagon.content.metadata.name | lower))) -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}

  {{- end -}}
{{- end -}}
