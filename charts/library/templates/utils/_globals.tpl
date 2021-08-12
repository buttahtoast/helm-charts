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
    {{- if and $storageClass (not (eq "-" $storageClass)) }}
      {{- printf "\"%s\"" $storageClass -}}
    {{- end }}
  {{- else }}
    {{- fail "Template requires '.context' as argument" }}
  {{- end }}
{{- end -}}
