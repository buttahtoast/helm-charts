{{/*
  Sprig Template - ReleaseName
*/}}
{{- define "lib.internal.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
  Sprig Template - Name
*/}}
{{- define "lib.internal.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
  Sprig Template - Fullname
*/}}
{{- define "lib.utils.fullname" -}}
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
    {{- $name_p := (default (include "lib.internal.name" $context) $name_p) }}
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
{{- define "lib.utils.selectorLabels" -}}
{{- if and $.Values.selectorLabels (kindIs "map" $.Values.selectorLabels) }}
  {{- include "lib.utils.template" (dict "value" $.Values.selectorLabels "context" $) | indent 0 }}
{{- else }}
app.kubernetes.io/name: {{ include "lib.internal.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
{{- end -}}


{{/*
  Sprig Template - DefaultLabels
*/}}
{{- define "lib.utils.defaultLabels" -}}
{{- include "lib.utils.selectorLabels" . }}
{{- if and .Chart.AppVersion (not .versionunspecific) }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end -}}


{{/*
  Sprig Template - OverwriteLabels
*/}}
{{- define "lib.utils.overwriteLabels" -}}
  {{- if and $.Values.overwriteLabels (kindIs "map" $.Values.overwriteLabels) }}
    {{- include "lib.utils.strings.template" (dict "value" $.Values.overwriteLabels "context" $) | nindent 0 }}
  {{- else }}
    {{- include "lib.utils.defaultLabels" . | indent 0}}
  {{- end }}
{{- end -}}


{{/*
  Sprig Template - CommonLabels
*/}}
{{- define "lib.utils.commonLabels" -}}
  {{- include "lib.utils.overwriteLabels" . | indent 0 }}
  {{- if and $.Values.commonLabels (kindIs "map" $.Values.commonLabels) }}
    {{- include "lib.utils.strings.template" (dict "value" $.Values.commonLabels "context" $) | nindent 0 }}
  {{- end }}
{{- end -}}


{{/*
  Sprig Template - Labels
*/}}
{{- define "lib.utils.labels" -}}
  {{- $_ := set (default . .context) "versionunspecific" (default false .versionUnspecific ) -}}
  {{- toYaml (mergeOverwrite (fromYaml (include "lib.utils.commonLabels" (default . .context))) (default dict .labels)) | indent 0 }}
  {{- $_ := unset (default . .context) "versionunspecific" }}
{{- end -}}


{{/*
  Sprig Template - KubernetesCapabilities
*/}}
{{- define "lib.utils.capabilities" -}}
  {{- default $.Capabilities.KubeVersion.GitVersion $.Values.kubeCapabilities }}
{{- end -}}
