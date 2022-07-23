{{/*
  ExtraEnvironment <Template>
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
  {{- if $.Values.global -}}
    {{- with $.Values.global.timezone }}
- name: "TZ"
  value: "{{ . }}"
    {{- end }}
    {{- if $.Values.proxy }}
        {{- $proxy := (fromYaml (include "lib.utils.strings.template" (dict "value" $.Values.proxy "context" $))) }}
        {{- if $proxy.httpProxy }}
            {{- if and ($proxy.httpProxy.host) ($proxy.httpProxy.port) }}
- name: "HTTP_PROXY"
  value: {{ printf "\"%s://%s:%s\"" (default "http" $proxy.httpProxy.protocol | toString) ($proxy.httpProxy.host | toString) ($proxy.httpProxy.port | toString) }}
        {{- end }}
    {{- end }}
    {{- if $proxy.httpsProxy }}
        {{- if and ($proxy.httpsProxy.host) ($proxy.httpsProxy.port) }}
- name: "HTTPS_PROXY"
  value: {{ printf "\"%s://%s:%s\"" (default "http" $proxy.httpsProxy.protocol | toString) ($proxy.httpsProxy.host | toString)  ($proxy.httpsProxy.port | toString) }}
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
  ExtraResources <Template>
*/}}
{{- define "lib.utils.extras.resources" -}}
  {{- if and $.Values.extraResources (kindIs "slice" $.Values.extraResources) }}
---
apiVersion: v1
kind: List
items: {{- include "lib.utils.strings.template" (dict "value" $.Values.extraResources "context" $) | nindent 2 }}
  {{- end }}
{{- end }}