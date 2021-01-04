{{/*
  Sprig Template - DockerImage
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
    {{- if $values.global }}
      {{- if  $values.global.imageRegistry }}
        {{- $registry =  $values.global.imageRegistry -}}
      {{- end -}}
      {{- if  $values.global.defaultTag }}
        {{- if not $tag }}
          {{- $tag =  $values.global.defaultTag }}
        {{- end }}
      {{- end }}
    {{- end -}}
    {{- $imagePath := "" }}
    {{- if and $registry $repository }}
      {{- $imagePath = (printf "%s/%s" (trimSuffix "/" $registry) $repository) }}
    {{- else }}
      {{- $imagePath = $repository }}
    {{- end }}
    {{- if and (not $tag) .default }}
      {{- $tag = .default }}
    {{- end }}
    {{- if $tag }}
      {{- printf "%s:%s" $imagePath (toString $tag) -}}
    {{- else }}
      {{- printf "%s" $imagePath -}}
    {{- end }}
  {{- else }}
    {{- fail "Template requires '.registry' and '.context' as arguments" }}
  {{- end }}
{{- end -}}


{{/*
  Sprig Template - ImagePullPolicy
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
    {{- fail "Template requires '.context' as argument" }}
  {{- end }}
{{- end -}}


{{/*
  Sprig Template - ImagePullsecrets
*/}}
{{- define "lib.utils.globals.imagePullSecrets" -}}
  {{- if .context }}
    {{- $secrets := (default "" .pullSecrets)}}
    {{- $values := default .context .context.Values }}
    {{- if $values.global }}
      {{- if $values.global.imagePullSecrets }}
        {{- $secrets = $values.global.imagePullSecrets -}}
      {{- end -}}
    {{- end -}}
    {{- if $secrets }}
      {{- toYaml $secrets | nindent 0 }}
    {{- end }}
  {{- else }}
    {{- fail "Template requires '.context' as argument" }}
  {{- end }}
{{- end }}


{{/*
  Sprig Template - StorageClass
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
    {{- if $storageClass }}
      {{- printf "\"%s\"" $storageClass -}}
    {{- end }}
  {{- else }}
    {{- fail "Template requires '.context' as argument" }}
  {{- end }}
{{- end -}}
