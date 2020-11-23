{{/*
  Sprig Template - ReleaseName
*/}}
{{- define "lib.utils.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
  Sprig Template - Name
*/}}
{{- define "lib.utils.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
  Sprig Template - Fullname
*/}}
{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
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
    {{- $name_p := default $context.Chart.Name (default $context.Values.nameOverride $name_p) -}}
      {{- if or (contains $name_p $context.Release.Name) (contains $context.Release.Name $name_p) -}}
        {{- $name = $prefix -}}
      {{- else -}}
        {{- $name = (printf "%s-%s" $prefix $name_p) -}}
     {{- end -}}
  {{- end -}}
  {{- printf "%s" (include "lib.utils.toDns1123" $name) }}
{{- end -}}


{{/*
  Sprig Template - Selector labels
*/}}
{{- define "lib.utils.selectorLabels" -}}
{{- if and $.Values.selectorLabels (kindIs "map" $.Values.selectorLabels) }}
  {{- toYaml $.Values.selectorLabels | indent 0 }}
{{- else }}
app.kubernetes.io/name: {{ include "lib.utils.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
{{- end -}}


{{/*
  Sprig Template - Default labels
*/}}
{{- define "lib.utils.defaultLabels" -}}
{{- include "lib.utils.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end -}}


{{/*
  Sprig Template - Overwrite Labels
*/}}
{{- define "lib.utils.overwriteLabels" -}}
  {{- if and $.Values.overwriteLabels (kindIs "map" $.Values.overwriteLabels) }}
    {{- include "lib.utils.template" (dict "value" $.Values.overwriteLabels "context" $) | nindent 0 }}
  {{- else }}
    {{- include "lib.utils.defaultLabels" . | indent 0}}
  {{- end }}
{{- end -}}


{{/*
  Sprig Template - Common Labels
*/}}
{{- define "lib.utils.commonLabels" -}}
  {{- include "lib.utils.overwriteLabels" . | indent 0 }}
  {{- if and $.Values.commonLabels (kindIs "map" $.Values.commonLabels) }}
    {{- include "lib.utils.utils.template" (dict "value" $.Values.commonLabels "context" $) | nindent 0 }}
  {{- end }}
{{- end -}}


{{/*
  Sprig Template - Labels
*/}}
{{- define "lib.utils.labels" -}}
  {{- toYaml (mergeOverwrite (fromYaml (include "lib.utils.commonLabels" (default . .context))) (default dict .labels)) | indent 0 }}
{{- end -}}


{{/*
  Sprig Template - KubernetesCapabilities
*/}}
{{- define "lib.utils.capabilities" -}}
  {{- default $.Capabilities.KubeVersion.GitVersion $.Values.kubeCapabilities }}
{{- end -}}
