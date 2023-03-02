{{/*
Expand the name of the chart.
*/}}
{{- define "kyverno-policies.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kyverno-policies.fullname" -}}
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
{{- define "kyverno-policies.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kyverno-policies.labels" -}}
helm.sh/chart: {{ include "kyverno-policies.chart" . }}
{{ include "kyverno-policies.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kyverno-policies.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kyverno-policies.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kyverno-policies.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "kyverno-policies.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "kyverno-policies.printTpl" -}}
{{- printf "{{ %s }}" $ | quote -}}
{{- end -}}

{{/* Base Label */}}
{{- define "kyverno-policies.labels.base" -}}
{{ $.Values.global.baseLabel | trimAll "." | trimAll "/" }}
{{- end -}}

{{/* Replicator Label */}}
{{- define "kyverno-policies.labels.replicator" -}}
{{- printf "replicator.%s" (include "kyverno-policies.labels.base" $) -}}
{{- end -}}

{{/* Kubeconfigs Labels/Annotations */}}
{{- define "kyverno-policies.kubeconfigs.base" -}}
{{- printf "kubecfg.%s" (include "kyverno-policies.labels.base" $) -}}
{{- end -}}

{{/* Label to select kubeconfig usage */}}
{{- define "kyverno-policies.kubeconfigs.use" -}}
{{- printf "%s/use" (include "kyverno-policies.kubeconfigs.base" $) -}}
{{- end -}}

{{/* Label to select kubeconfig type */}}
{{- define "kyverno-policies.kubeconfigs.type" -}}
{{- printf "%s/type" (include "kyverno-policies.kubeconfigs.base" $) -}}
{{- end -}}

{{/* Annotation to select kubeconfig secret name */}}
{{- define "kyverno-policies.kubeconfigs.name" -}}
{{- printf "%s/name" (include "kyverno-policies.kubeconfigs.base" $) -}}
{{- end -}}

{{/* Annotation to select kubeconfig secret namespace */}}
{{- define "kyverno-policies.kubeconfigs.namespace" -}}
{{- printf "%s/namespace" (include "kyverno-policies.kubeconfigs.base" $) -}}
{{- end -}}

{{/* Annotation to select kubeconfig secret key */}}
{{- define "kyverno-policies.kubeconfigs.key" -}}
{{- printf "%s/key" (include "kyverno-policies.kubeconfigs.base" $) -}}
{{- end -}}

