{{/*
  CSGO - Ports
*/}}
{{- define "csgo.ports" -}}
  {{- if not (eq ($.Values.config.port | toString) ($.Values.config.port_tv | toString)) }}
    {{- if $.Values.statefulset.ports }}
      {{- toYaml $.Values.statefulset.ports | nindent 0 }}
    {{- end }}
- name: srcds
  containerPort: {{ $.Values.config.port }}
  protocol: TCP
    {{- if $.Values.tv.enabled }}
- name: srcds-tv
  containerPort: {{ $.Values.tv.port }}
  protocol: TCP
    {{- end }}
  {{- else }}
    {{- fail "SRCDS Port can not be the same value as TV Port" }}
  {{- end }}
{{- end }}


{{/*
  CSGO - Environment Variables
*/}}
{{- define "csgo.environment" -}}
  {{- $config := $.Values.config }}
  {{- if and $config.rcon_password (kindIs "string" $config.rcon_password) }}
- name: SRCDS_RCONPW
  valueFrom:
    secretKeyRef:
      name: {{ include "lib.utils.fullname" $ }}-config
      key: SRCDS_RCONPW
  {{- end }}
  {{- if and $config.password (kindIs "string" $config.password)  }}
- name: SRCDS_PW
  valueFrom:
    secretKeyRef:
      name: {{ include "lib.utils.fullname" $ }}-config
      key: SRCDS_PW
  {{- end }}
- name: "SRCDS_PORT"
  value: {{ $config.port }}
  {{- if $.Values.tv.enabled }}
- name: "SRCDS_TV_PORT"
  value: {{ $.Values.tv.port }}
  {{- end }}
- name: "SRCDS_HOSTNAME"
  value: {{ $config.hostname }}
- name: "SRCDS_NET_PUBLIC_ADDRESS"
  value: {{ $config.public_address }}
- name: "SRCDS_IP"
  value: {{ $config.local_address }}
- name: "SRCDS_FPSMAX"
  value: {{ $config.maxfps }}
- name: "SRCDS_TICKRATE"
  value: {{ $config.tickrate }}
- name: "SRCDS_MAXPLAYERS"
  value: {{ $config.maxplayers }}
- name: "SRCDS_REGION"
  value: {{ $config.region }}
- name: "SRCDS_STARTMAP"
  value: {{ $config.map.start }}
- name: "SRCDS_MAPGROUP"
  value: {{ $config.map.group }}
- name: "SRCDS_GAMETYPE"
  value: {{ $config.game.type }}
- name: "SRCDS_GAMEMODE"
  value: {{ $config.game.mode }}
  {{- if and $config.workshop.start_map (kindIs "int" $config.workshop.start_map) }}
- name: "SRCDS_WORKSHOP_START_MAP"
  value: {{ $config.workshop.start_map }}
  {{- end }}
  {{- if and $config.workshop.collection (kindIs "int" $config.workshop.collection) }}
- name: "SRCDS_HOST_WORKSHOP_COLLECTION"
  value: {{ $config.workshop.collection }}
  {{- end }}
  {{- if and $config.workshop.auth (kindIs "string" $config.workshop.auth) }}
- name: SRCDS_WORKSHOP_AUTHKEY
  valueFrom:
    secretKeyRef:
      name: {{ include "lib.utils.fullname" $ }}
      key: SRCDS_WORKSHOP_AUTHKEY
  {{- end }}
  {{- if and $config.workshop.additional_args (kindIs "slice" $config.workshop.additional_args) }}
- name: ADDITIONAL_ARGS
  value: {{- printf "%s" ($config.workshop.additional_args | join " ") }}
  {{- end }}
  {{- if $.Values.environment -}}
    {{- toYaml $.Values.environment | nindent 0 -}}
  {{- end }}
{{- end }}
