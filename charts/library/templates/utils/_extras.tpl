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
{{- if $.Values.timezone }}
- name: "TZ"
  value: "{{ $.Values.timezone }}"
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
  Sprig Template - ExtraResources
*/}}
{{- define "lib.utils.extras.resources" -}}
  {{- if and $.Values.extraResources (kindIs "slice" $.Values.extraResources) }}
---
apiVersion: v1
kind: List
items: {{- include "lib.utils.strings.template" (dict "value" $.Values.extraResources "context" $) | nindent 2 }}
  {{- end }}
{{- end }}
