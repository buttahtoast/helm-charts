{{/*
  Resolve Subgroup references of groups an return relevant components

  params <dict>: 
    role: <strict> Role Name to resolve
    roles: <dict> All avaiable roles
    ctx: <dict> Global Context

  returns <dict>:
    cpts: <slice> Components

*/}}
{{- define "inventory.groups.resolve" -}}
  {{- $resv_cpts := list -}}
  {{- $resv_roles := list -}}
  {{- if (include "lib.utils.lists.hasValueByKey" (dict "list" .roles "value" .role "key" "name")) -}}
    {{- $resv_roles = append $resv_roles .role -}}
    {{- $role := fromYaml (include "lib.utils.lists.getValueByKey" (dict "list" .roles "value" .role "key" "name")) -}}
    {{- if and $role.components (kindIs "slice" $role.components) -}}
      {{- range $role.components -}}
        {{- if . -}}
          {{- $resv_cpts = append $resv_cpts . -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
    {{- if and $role.groups (kindIs "slice" $role.groups) -}}
      {{- range $role.groups -}}
        {{- $resv_subrole := fromYaml (include "inventory.groups.resolve" (dict "role" . "roles" $.roles "ctx" $.ctx)) }}
        {{- $resv_cpts = concat $resv_cpts $resv_subrole.cpts -}}
        {{- $resv_roles = concat $resv_roles $resv_subrole.roles -}}
      {{- end -}}
    {{- end -}}
    {{- printf "%s" (toYaml (dict "cpts" $resv_cpts "roles" $resv_roles)) -}}
  {{- else -}}
    {{- include "inventory.helpers.fail" (printf "Referenced role '%s' does not exist" .role) -}}
  {{- end -}}
{{- end }}