{{/*
  Sprig Template - DockerImage
*/}}
{{- define "lib.utils.image" -}}
  {{- if and .registry .context }}
    {{- $registry := "" }}
    {{- $repository := "" }}
    {{- $tag := "" }}
    {{- $global := dict }}
    {{- $values := .registry }}
    {{- if $values.image }}
      {{- $registry = (required "Missing key '.image.registry' in image structure" $values.image.registry) -}}
      {{- $repository = (required "Missing key '.image.repository' in image structure" $values.image.repository) -}}
      {{- $tag = (default (default "" .default) $values.image.tag) -}}
    {{- else }}
      {{- $registry = (required "Missing key '.registry' in image structure" $values.registry) -}}
      {{- $repository = (required "Missing key '.repository' in image structure" $values.repository) -}}
      {{- $tag = (default (default "" .default) $values.tag) -}}
    {{- end }}
    {{- if .context.Values }}
      {{- $global = .context.Values }}
    {{- else }}
      {{- $global = .context }}
    {{- end }}
    {{- if $global.global }}
      {{- if $global.global.imageRegistry }}
        {{- $registry = $global.global.imageRegistry -}}
      {{- end -}}
    {{- end -}}
    {{- if $tag }}
      {{- printf "%s/%s:%s" (trimSuffix "/" $registry) $repository (toString $tag) -}}
    {{- else }}
      {{- printf "%s/%s" (trimSuffix "/" $registry) $repository -}}
    {{- end }}
  {{- else }}
    {{- fail "Template requires '.registry' and '.context' as arguments" }}
  {{- end }}
{{- end -}}


{{/*
  Sprig Template - ImagePullPolicy
*/}}
{{- define "lib.utils.imagePullPolicy" -}}
  {{- if and .imagePullPolicy .context }}
    {{- $policy := "" }}
    {{- $tag := "" }}
    {{- $values := default .context .context.Values }}
    {{- if .pullPolicy.image }}
      {{- $policy = .pullPolicy.image.imagePullPolicy -}}
    {{- else }}
      {{- $policy = .imagePullPolicy -}}
    {{- end }}
    {{- if $values.global }}
      {{- if $values.global.pullPolicy }}
        {{- $policy = $values.global.pullPolicy }}
      {{- end }}
    {{- end }}
    {{- printf "%s" (default "" $policy) }}
  {{- else }}
    {{- fail "Template requires '.pullPolicy' and '.context' as arguments" }}
  {{- end }}
{{- end -}}


{{/*
  Sprig Template - ImagePullsecrets
*/}}
{{- define "lib.utils.imagePullSecrets" -}}
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
    {{- fail "Template requires '.context' as arguments" }}
  {{- end }}
{{- end }}


{{/*
  Sprig Template - StorageClass
*/}}
{{- define "lib.utils.storageClass" -}}
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
    {{- fail "Template requires '.context' as arguments" }}
  {{- end }}
{{- end -}}
