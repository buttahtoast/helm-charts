{{/*
  Sprig Template - ExtraEnvironment
*/}}
{{- define "lib.utils.extras.environment" -}}
- name: NODE_NAME
  valueFrom:
    fieldRef:
      fieldPath: spec.nodeName
- name: POD_NAME
  valueFrom:
    fieldRef:
      fieldPath: metadata.name
- name: POD_NAMESPACE
  valueFrom:
    fieldRef:
      fieldPath: metadata.namespace
- name: POD_IP
  valueFrom:
    fieldRef:
      fieldPath: status.podIP
- name: POD_SERVICE_ACCOUNT
  valueFrom:
    fieldRef:
      fieldPath: spec.serviceAccountName
{{- if .Values.proxy }}
    {{- $proxy := (fromYaml (include "lib.utils.template" (dict "value" .Values.proxy "context" $))) }}
    {{- if $proxy.httpProxy }}
        {{- if and ($proxy.httpProxy.host) ($proxy.httpProxy.port) }}
- name: "HTTP_PROXY"
  value: {{ printf "\"%s://%s:%s\"" (default "http" $proxy.httpProxy.protocol) $proxy.httpProxy.host $proxy.httpProxy.port }}
        {{- end }}
    {{- end }}
    {{- if $proxy.httpsProxy }}
        {{- if and ($proxy.httpsProxy.host) ($proxy.httpsProxy.port) }}
- name: "HTTPS_PROXY"
  value: {{ printf "\"%s://%s:%s\"" (default "http" $proxy.httpsProxy.protocol) $proxy.httpsProxy.host $proxy.httpsProxy.port }}
        {{- end }}
    {{- end }}
    {{- if $proxy.noProxy }}
- name: "NO_PROXY"
       {{- if kindIs "slice" $proxy.noProxy }}
  value: {{ (join ", " $proxy.noProxy) | quote }}
       {{- else }}
  value: {{ $proxy.noProxy | quote }}
       {{- end }}
    {{- end }}
    {{- end }}
{{- end -}}


{{/*
  Sprig Template - ExtraResources
*/}}
{{- define "lib.utils.extras.resources" -}}
  {{- if and $.Values.extraResources (kindIs "slice" $.Values.extraResources) }}
---
apiVersion: v1
kind: List
items: {{- include "lib.utils.template" (dict "value" $.Values.extraResources "context" $) | nindent 2 }}
  {{- end }}
{{- end }}
