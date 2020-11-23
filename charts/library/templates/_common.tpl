{{/*
  Create chart name and version as used by the chart label (Default Name)
*/}}
{{- define "lib.utils.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
  Expand the name of the chart.
*/}}
{{- define "lib.utils.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}



{{/*
  Template - Selector labels
*/}}
{{- define "lib.utils.selectorLabels" -}}
{{- if $.Values.selectorLabels (kindIs "map" $.Values.selectorLabels) }}
  {{- toYaml $.Values.selectorLabels | indent 0 }}
{{- else }}
app.kubernetes.io/name: {{ include "bedag-lib.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
{{- end -}}


{{/*
  Template - Default labels
*/}}
{{- define "lib.utils.defaultLabels" -}}
{{- include "lib.utils.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end -}}

{{/*
  Template - Overwrite Labels
*/}}
{{- define "lib.utils.overwriteLabels" -}}
  {{- if and $.Values.overwriteLabels (kindIs "map" $.Values.overwriteLabels) }}
    {{- include "lib.utils.template" (dict "value" $.Values.overwriteLabels "context" $) | nindent 0 }}
  {{- else }}
    {{- include "lib.utils.defaultLabels" . | indent 0}}
  {{- end }}
{{- end -}}


{{/*
  Template - Common Labels
*/}}
{{- define "lib.utils.commonLabels" -}}
  {{- include "lib.utils.overwriteLabels" . | indent 0 }}
  {{- if and $.Values.commonLabels (kindIs "map" $.Values.commonLabels) }}
    {{- include "lib.utils.utils.template" (dict "value" $.Values.commonLabels "context" $) | nindent 0 }}
  {{- end }}
{{- end -}}

{{/*
  Template - Labels
*/}}
{{- define "lib.utils.labels" -}}
  {{- toYaml (mergeOverwrite (fromYaml (include "lib.utils.commonLabels" (default . .context))) (default dict .labels)) | indent 0 }}
{{- end -}}










{{/*
  Template - Overwrite Kubernetes Capabilities
*/}}
{{- define "lib.utils.capabilities" -}}
  {{- default $.Capabilities.KubeVersion.GitVersion $.Values.kubeCapabilities }}
{{- end -}}
