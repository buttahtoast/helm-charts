{{/*
Global Docker Registry

  This function overwrites local docker registries with global defined registries, if available.

Arguments

  If an as required marked argument is missing, the template engine will intentionaly.

  * .registry - Local Registry definition, see the structure below.
  * .context - Inherited Root Context (Required). Make sure global variables are accessible through the context.
  * .default - Add a default value for the tag, if not set explicit (Optional, Defaults to "latest")

Structure

  The following structure is expected for the key '.registry'. Keys with a '*' are optional. If on a parent key, this means you can
  add the structure with the parent key or just the structure within the parent key.

  image*:
    registry: docker.io
    repository: bitnami/apache
    tag*: latest

Returns

  String

Usage

  {{- include "lib.utils.registry" (dict "registry" .Values.image "context" $ "default" .Chart.AppVersion) }}

*/}}
{{- define "lib.utils.registry" -}}
  {{- if and .registry .context }}
    {{- $registry := "" }}
    {{- $repository := "" }}
    {{- $tag := "" }}
    {{- $global := dict }}
    {{- $values := .registry }}
    {{- if $values.image }}
      {{- $registry = (required "Missing key '.image.registry' in image structure" $values.image.registry) -}}
      {{- $repository = (required "Missing key '.image.repository' in image structure" $values.image.repository) -}}
      {{- $tag = (default (default "latest" .default) $values.image.tag) -}}
    {{- else }}
      {{- $registry = (required "Missing key '.registry' in image structure" $values.registry) -}}
      {{- $repository = (required "Missing key '.repository' in image structure" $values.repository) -}}
      {{- $tag = (default (default "latest" .default) $values.tag) -}}
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
    {{- printf "%s/%s:%s" (trimSuffix "/" $registry) $repository (toString $tag) -}}
  {{- else }}
    {{- fail "Template requires '.registry' and '.context' as arguments" }}
  {{- end }}
{{- end -}}


{{/*
Global Image Pull Policy

  This function overwrites local pullSecrets with global defined pullSecrets, if available.

Arguments

  If an as required marked argument is missing, the template engine will intentionaly.

  * .pullSecrets - Local pullSecrets, which are overwritten if the global variable is set. If neither is set, an empty string is returned (Required).
  * .context - Inherited Root Context (Required). Make sure global variables are accessible through the context.

Returns

  String/YAML Structure

Usage

  {{- include "lib.utils.pullPolicy" (dict "pullPolicy" .Values.imagePullSecrets "context" $) }}

*/}}
{{- define "lib.utils.pullPolicy" -}}
  {{- if and .pullPolicy .context }}
    {{- $policy := "" }}
    {{- $tag := "" }}
    {{- $global := dict }}
    {{- if .pullPolicy.image }}
      {{- $policy = .pullPolicy.pullPolicy -}}
    {{- else }}
      {{- $policy = .pullPolicy -}}
    {{- end }}
    {{- if .context.Values }}
      {{- $global = .context.Values }}
    {{- else }}
      {{- $global = .context }}
    {{- end }}
    {{- if $global.global }}
      {{- if $global.global.pullPolicy }}
        {{- $policy = $global.global.pullPolicy }}
      {{- end }}
    {{- end }}
    {{- printf "%s" (default "" $policy) }}
  {{- else }}
    {{- fail "Template requires '.pullPolicy' and '.context' as arguments" }}
  {{- end }}
{{- end -}}


{{/*
Global Image Pullsecrets

  This function overwrites local pullSecrets with global defined pullSecrets, if available.

Arguments

  If an as required marked argument is missing, the template engine will intentionaly.

  * .pullSecrets - Local pullSecrets, which are overwritten if the global variable is set. If neither is set, an empty string is returned (Optional, Defaults to empty).
  * .context - Inherited Root Context (Required). Make sure global variables are accessible through the context.

Returns

  String/YAML Structure

Usage

  {{- include "lib.utils.imagePullSecrets" (dict "pullSecrets" .Values.imagePullSecrets "context" $) }}

*/}}
{{- define "lib.utils.imagePullSecrets" -}}
  {{- if .context }}
    {{- $secrets := (default "" .pullSecrets)}}
    {{- $global := dict }}
    {{- if .context.Values }}
      {{- $global = .context.Values }}
    {{- else }}
      {{- $global = .context }}
    {{- end }}
    {{- if $global.global }}
      {{- if $global.global.imagePullSecrets }}
        {{- $secrets = $global.global.imagePullSecrets -}}
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
Global StorageClass

  This Function checks for a global storage class and returns it, if set.
  With the Parameter "persistence" you can pass your persistence structure. The function
  is looking for a storageClass definition. If the Kind of the "persistence" is string,
  it's assumed the storageClass was directly given. If not, the function will look for a .storageClass
  in the given structure.

Arguments

  If an as required marked argument is missing, the template engine will intentionaly.

  * .persistence - Local StorageClass/Persistence configuration, see the structure below.
  * .context - Inherited Root Context (Required). Make sure global variables are accessible through the context.

Structure

  The following structure is expected for the key '.registry'. Keys with a '*' are optional. If on a parent key, this means you can
  add the structure with the parent key or just the structure within the parent key.

  persistence*:
    storageClass: "local-storage"

Returns

  String

Usage

  {{ include "lib.utils.storageClass" (dict "persistence" .Values.persistence "context" $) }}

*/}}
{{- define "lib.utils.storageClass" -}}
  {{- if .context }}
    {{- $storageClass := "" }}
    {{- $global := dict }}
    {{- if typeIs "string" .persistence }}
      {{- $storageClass = .persistence -}}
    {{- else }}
      {{- $storageClass = (default "" .persistence.storageClass) -}}
    {{- end }}
    {{- if .context.Values }}
      {{- $global = .context.Values }}
    {{- else }}
      {{- $global = .context }}
    {{- end }}
    {{- if $global.global }}
        {{- if $global.global.storageClass }}
            {{- $storageClass = .context.global.storageClass -}}
        {{- end -}}
    {{- end -}}
    {{- if $storageClass }}
      {{- printf "\"%s\"" $storageClass -}}
    {{- end }}
  {{- else }}
    {{- fail "Template requires '.context' as arguments" }}
  {{- end }}
{{- end -}}
