{{/*
Expand the name of the chart.
*/}}
{{- define "helm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "helm.fullname" -}}
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
{{- define "helm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "helm.labels" -}}
helm.sh/chart: {{ include "helm.chart" . }}
{{ include "helm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "helm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "helm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
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

{{/*
Create the fully-qualified Docker image to use
*/}}
{{- define "helm.fullyQualifiedDockerImagePlane" -}}
{{- printf "%s/%s:%s" .Values.headplane.plane.image.registry .Values.headplane.plane.image.repository .Values.headplane.plane.image.tag -}}
{{- end }}

{{/*
Create the fully-qualified Docker image to use
*/}}
{{- define "helm.fullyQualifiedDockerImageScale" -}}
{{- printf "%s/%s:%s" .Values.headplane.scale.image.registry .Values.headplane.scale.image.repository .Values.headplane.scale.image.tag -}}
{{- end }}


{{/*
Determine the Kubernetes version to use for jobsFullyQualifiedDockerImage tag
*/}}
{{- define "helm.jobsTagKubeVersion" -}}
{{- if contains "-eks-" .Capabilities.KubeVersion.GitVersion }}
{{- print "v" .Capabilities.KubeVersion.Major "." (.Capabilities.KubeVersion.Minor | replace "+" "") -}}
{{- else }}
{{- print "v" .Capabilities.KubeVersion.Major "." .Capabilities.KubeVersion.Minor -}}
{{- end }}
{{- end }}

{{/*
Create the jobs fully-qualified Docker image to use
*/}}
{{- define "helm.jobsFullyQualifiedDockerImage" -}}
{{- $Values := $.Values.global.jobs.kubectl  -}}

{{- if $Values.image.tag }}
{{- printf "%s/%s:%s" $Values.image.registry $Values.image.repository $Values.image.tag -}}
{{- else }}
{{- printf "%s/%s:%s" $Values.image.registry $Values.image.repository (include "helm.jobsTagKubeVersion" .) -}}
{{- end }}
{{- end }}

