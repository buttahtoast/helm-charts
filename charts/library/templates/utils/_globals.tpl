{{/*
  DockerImage <Template>
*/}}
{{- define "lib.utils.globals.image" -}}
  {{- if and .image .context }}
    {{- $values := default .context .context.Values }}
    {{- $image := .image }}
    {{- if and $image.image (kindIs "map" $image.image) }}
      {{- $image = $image.image }}
    {{- end }}
    {{- $registry := $image.registry -}}
    {{- $repository := (required "Missing key '.repository' in image structure" $image.repository) -}}
    {{- $tag := (default "" $image.tag) -}}
    {{- $digest := (default "" $image.digest) }}
    {{- if $values.global }}
      {{- if  $values.global.imageRegistry }}
        {{- $registry =  $values.global.imageRegistry -}}
      {{- end -}}
      {{- if and (not $digest) (not $tag) }}
        {{- if $values.global.defaultTag }}
          {{- $tag = $values.global.defaultTag }}
        {{- end }}
      {{- end }}  
    {{- end -}}
    {{- $imagePath := "" }}
    {{- if and $registry $repository }}
      {{- $imagePath = (printf "%s/%s" (trimSuffix "/" $registry) $repository) }}
    {{- else }}
      {{- $imagePath = $repository }}
    {{- end }}
    {{- if not $digest }}
      {{- if and (not $tag) .default }}
        {{- $tag = .default }}
      {{- end }}
    {{- end }}  
    {{- if $digest }}
      {{- printf "%s@%s" $imagePath (toString $digest) -}}
    {{- else if $tag }}
      {{- printf "%s:%s" $imagePath (toString $tag) -}}
    {{- else }}
      {{- printf "%s" $imagePath -}}
    {{- end }}
  {{- else }}
    {{- include "lib.utils.errors.params" (dict "tpl" "lib.utils.globals.imagePullPolicy" "params" (list "registry" "context")) -}}
  {{- end }}
{{- end -}}


{{/*
  ImagePullPolicy <Template>
*/}}
{{- define "lib.utils.globals.imagePullPolicy" -}}
  {{- if .context }}
    {{- $values := default .context .context.Values }}
    {{- $imagePullPolicy := .imagePullPolicy }}
    {{- if and $imagePullPolicy.image (kindIs "map" $imagePullPolicy.image) }}
      {{- $imagePullPolicy = $imagePullPolicy.image -}}
    {{- end }}
    {{- $policy := $imagePullPolicy.imagePullPolicy -}}
    {{- if $values.global }}
      {{- if $values.global.imagePullPolicy }}
        {{- $policy = $values.global.imagePullPolicy }}
      {{- end }}
    {{- end }}
    {{- if $policy }}
      {{- printf "%s" $policy }}
    {{- end }}
  {{- else }}
    {{- include "lib.utils.errors.params" (dict "tpl" "lib.utils.globals.imagePullPolicy" "params" (list "context")) -}}
  {{- end }}
{{- end -}}


{{/*
  ImagePullsecrets <Template>
*/}}
{{- define "lib.utils.globals.imagePullSecrets" -}}
  {{- if .context }}
    {{- $secrets := list }}
    {{- if (kindIs "slice" .pullSecrets) -}}
      {{- $secrets = .pullSecrets }}
    {{- end }}
    {{- $values := default .context .context.Values }}
    {{- if $values.global }}
      {{- if and $values.global.imagePullSecrets (kindIs "slice" $values.global.imagePullSecrets) }}
        {{- $secrets = (concat $secrets $values.global.imagePullSecrets) -}}
      {{- end -}}
    {{- end -}}
    {{- if $secrets }}
imagePullSecrets: {{- toYaml $secrets | nindent 0 }}
    {{- end }}
  {{- else }}
    {{- include "lib.utils.errors.params" (dict "tpl" "lib.utils.globals.imagePullSecrets" "params" (list "context")) -}}
  {{- end }}
{{- end }}


{{/*
  StorageClass <Template>
*/}}
{{- define "lib.utils.globals.storageClass" -}}
  {{- if .context }}
    {{- $storageClass := "" }}
    {{- $values := default .context .context.Values }}
    {{- if typeIs "string" .persistence }}
      {{- $storageClass = .persistence -}}
    {{- else }}
      {{- $storageClass = (default "" .persistence.storageClass) -}}
    {{- end }}
    {{- if $values.global }}
        {{- if $values.global.storageClass }}
            {{- $storageClass = $values.global.storageClass -}}
        {{- end -}}
    {{- end -}}
    {{- if and $storageClass (not (eq "-" $storageClass)) }}
      {{- printf "\"%s\"" $storageClass -}}
    {{- end }}
  {{- else }}
    {{- include "lib.utils.errors.params" (dict "tpl" "lib.utils.globals.storageClass" "params" (list "context")) -}}
  {{- end }}
{{- end -}}
