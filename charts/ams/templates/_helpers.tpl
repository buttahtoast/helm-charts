{{/*
Expand the name of the chart.
*/}}
{{- define "ant-media.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ant-media.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ant-media.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ant-media.labels" -}}
helm.sh/chart: {{ include "ant-media.chart" . }}
{{ include "ant-media.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ant-media.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ant-media.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ant-media.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ant-media.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "helm.utils.template" -}}
  {{- if $.ctx }}
    {{- if typeIs "string" $.tpl }}
      {{- tpl  $.tpl $.ctx  | replace "+|" "\n" }}
    {{- else }}
      {{- tpl ($.tpl | toYaml) $.ctx | replace "+|" "\n" }}
    {{- end }}
  {{- end }}
{{- end -}}

{{- define "helm.utils.envs" -}}
  {{- range $key, $value := $.envs }}
- name: {{ $key }}
  value: {{ include "helm.utils.template" (dict "tpl" $value "ctx" $.ctx) }} 
  {{- end }}
{{- end -}}


{{- define "ant-media.common.args" -}}
{{- with $.Values.config }}
- "-c"
- {{ .limits.cpu | quote }}
- "-e"
- {{ .limits.memory | quote }}
- "-m"
- {{ .mode | quote }}
{{- end }}
{{- if $.Values.kafka.enabled }}
- "-k"
{{- end }}
{{- with (include "ant-media.connectionString" $) }}
- "-h"
- "{{ . }}"
{{- end }}
{{- end }}

{{- define "ant-media.common.env" -}}
- name: REDISCLI_AUTH
  valueFrom:
    secretKeyRef:
      name: {{ $.Release.Name }}-redis
      key: redis-password
{{- end }}

{{- define "ant-media.connectionString" -}}
    {{- printf "/usr/local/antmedia/redis.yaml" -}}
{{- end }}

{{- define "ant-media.connectionStringDraft" -}}
  {{- $endpoint := (printf "%s-redis-headless:6379" $.Release.Name) -}}
  {{- $provider := "redis" -}}
  {{- $auth := ":${REDIS_PASSWORD}" -}}


  {{- if $auth -}}
    {{- printf "%s://%s@%s" $provider $auth $endpoint -}}
  {{- else -}}
    {{- printf "%s://%s" $provider $endpoint -}}
  {{- end -}}
{{- end }}

