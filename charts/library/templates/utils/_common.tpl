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
  Sprig Template - ReleaseName
*/}}
{{- define "lib.internal.common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
  Sprig Template - Name
*/}}
{{- define "lib.internal.common.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
  Sprig Template - Fullname
*/}}
{{- define "lib.utils.common.fullname" -}}
  {{- $context := default . .context -}}
  {{- $name_p := default $context.name .name -}}
  {{- $fullname_p := default $context.fullname .fullname  -}}
  {{- $prefix := default $context.Release.Name .prefix }}
  {{- $name := "" -}}
  {{- if $context.Values.fullnameOverride -}}
    {{- if $name_p }}
      {{- $name = (printf "%s-%s" $context.Values.fullnameOverride $name_p) -}}
    {{- else }}
      {{- $name = $context.Values.fullnameOverride -}}
    {{- end }}
  {{- else if $fullname_p }}
    {{- $name = $fullname_p -}}
  {{- else -}}
    {{- $name_p := (default (include "lib.internal.common.name" $context) $name_p) }}
      {{- if or (contains $name_p $context.Release.Name) (contains $context.Release.Name $name_p) -}}
        {{- $name = $prefix -}}
      {{- else -}}
        {{- $name = (printf "%s-%s" $prefix $name_p) -}}
     {{- end -}}
  {{- end -}}
  {{- printf "%s" (include "lib.utils.strings.toDns1123" $name) }}
{{- end -}}


{{/*
  Sprig Template - SelectorLabels
*/}}
{{- define "lib.utils.common.selectorLabels" -}}
{{- if and $.Values.selectorLabels (kindIs "map" $.Values.selectorLabels) }}
  {{- include "lib.utils.strings.template" (dict "value" $.Values.selectorLabels "context" $) | indent 0 }}
{{- else }}
app.kubernetes.io/name: {{ include "lib.internal.common.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
{{- end -}}


{{/*
  Sprig Template - DefaultLabels
*/}}
{{- define "lib.utils.common.defaultLabels" -}}
{{- include "lib.utils.common.selectorLabels" . }}
{{- if and .Chart.AppVersion (not .versionunspecific) }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end -}}


{{/*
  Sprig Template - OverwriteLabels
*/}}
{{- define "lib.utils.common.overwriteLabels" -}}
  {{- if and $.Values.overwriteLabels (kindIs "map" $.Values.overwriteLabels) }}
    {{- include "lib.utils.strings.template" (dict "value" $.Values.overwriteLabels "context" $) | nindent 0 }}
  {{- else }}
    {{- include "lib.utils.common.defaultLabels" . | indent 0}}
  {{- end }}
{{- end -}}


{{/*
  Sprig Template - CommonLabels
*/}}
{{- define "lib.utils.common.commonLabels" -}}
  {{- include "lib.utils.common.overwriteLabels" . | indent 0 }}
  {{- if and $.Values.commonLabels (kindIs "map" $.Values.commonLabels) }}
    {{- include "lib.utils.strings.template" (dict "value" $.Values.commonLabels "context" $) | nindent 0 }}
  {{- end }}
{{- end -}}


{{/*
  Sprig Template - Labels
*/}}
{{- define "lib.utils.common.labels" -}}
  {{- $_ := set (default . .context) "versionunspecific" (default false .versionUnspecific ) -}}
  {{- toYaml (mergeOverwrite (fromYaml (include "lib.utils.common.commonLabels" (default . .context))) (default dict .labels)) | indent 0 }}
  {{- $_ := unset (default . .context) "versionunspecific" }}
{{- end -}}


{{/*
  Sprig Template - KubernetesCapabilities
*/}}
{{- define "lib.utils.common.capabilities" -}}
  {{- default $.Capabilities.KubeVersion.GitVersion $.Values.kubeCapabilities }}
{{- end -}}
