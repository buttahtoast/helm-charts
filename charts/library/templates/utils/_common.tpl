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
  Sprig Template - Name Check
*/}}
{{- define "lib.internal.common.nameCheck" -}}
  {{- if or (contains .name .context.Release.Name) (contains $context.Release.Name $name_p) -}}
       {{- printf "%s" $prefix -}}
      {{- else -}}
        {{- $name = (printf "%s-%s" $prefix $name_p) -}}
     {{- end -}}
{{- end -}}




{{/*
  Sprig Template - Fullname
*/}}
{{- define "lib.utils.common.fullname" -}}
  {{- $context := default . .context -}}
  {{- $name := default $context.name .name -}}
  {{- $fullname := default $context.fullname .fullname  -}}
  {{- $prefix := default $context.Release.Name .prefix }}
  {{- $return := "" -}}
  {{- if $fullname }}
    {{- $return = $fullname -}}
  {{ - else if $name_p }}
    {{- if or (contains $name $prefix) (contains $name $prefix) -}}
      {{- $return = (printf "%s" $prefix) -}}
    {{- else -}}
      {{- $return = (printf "%s-%s" $prefix $name) -}}
    {{- end -}}

  {{- else if $context.Values.fullnameOverride -}}
    {{- $name = $context.Values.fullnameOverride -}}
  {{- else }}
    {{- $name = (default (include "lib.internal.common.name" $context) $name_p) }}
  {{- else -}}
    {{- $name_p := (default (include "lib.internal.common.name" $context) $name_p) }}
      {{- if or (contains $name_p $context.Release.Name) (contains $context.Release.Name $name_p) -}}
        {{- $name = $prefix -}}
      {{- else -}}
        {{- $name = (printf "%s-%s" $prefix $name_p) -}}
     {{- end -}}
  {{- end -}}



  {{- if (contains "RELEASE-NAME" $name) }}
    {{- printf "%s" $name }}
  {{- else }}
    {{- printf "%s" (include "lib.utils.strings.toDns1123" $name) }}
  {{- end }}
{{- end -}}

{{/*
  Sprig Template - BaseLabels
*/}}
{{- define "lib.utils.common.defaultSelectorLabels" -}}
app.kubernetes.io/name: {{ include "lib.utils.common.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
  Sprig Template - SelectorLabels
*/}}
{{- define "lib.utils.common.selectorLabels" -}}
  {{- if $.Values.selectorLabels }}
  {{- include "lib.utils.strings.template" (dict "value" $.Values.selectorLabels "context" $) | indent 0 }}
  {{- else }}
{{- include "lib.utils.common.defaultSelectorLabels" $ | nindent 0 }}
  {{- end }}
{{- end -}}

{{/*
  Sprig Template - DefaultLabels
*/}}
{{- define "lib.utils.common.defaultLabels" -}}
{{- include "lib.utils.common.defaultSelectorLabels" $ | nindent 0 }}
  {{- if and .Chart.AppVersion (not .versionunspecific) }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
  {{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}  
{{- end -}}

{{/*
  Sprig Template - CommonLabels
*/}}
{{- define "lib.utils.common.commonLabels" -}}
  {{- if and $.Values.overwriteLabels (kindIs "map" $.Values.overwriteLabels) }}
    {{- include "lib.utils.strings.template" (dict "value" $.Values.overwriteLabels "context" $) | nindent 0 }}
  {{- else }}
    {{- include "lib.utils.common.defaultLabels" . | indent 0 }}
    {{- if and $.Values.commonLabels (kindIs "map" $.Values.commonLabels) }}
      {{- include "lib.utils.strings.template" (dict "value" $.Values.commonLabels "context" $) | nindent 0 }}
    {{- end }}
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
  {{- $capability := $.Capabilities.KubeVersion.Version -}}
  {{- if .Values.global -}}
    {{- if $.Values.global.kubeCapabilities -}}
      {{- $capability = $.Values.global.kubeCapabilities -}}
    {{- end -}}
  {{- end -}}
  {{- printf "%s" $capability -}}
{{- end -}}