{{/*
  Resolve Subgroup references of groups an return relevant components

  params <dict>: 
    role: <dict> Role to resolve
    roles: <dict> All avaiable roles
    context: <dict> $

  returns <dict>:
    name: <string> RoleName
    components: <slice> Components
    default*: <bool> Default
 
*/}}
{{- define "inventory.groups.components" -}}
  {{- $groups_base := (fromYaml (include "inventory.config.resolve" (dict "path" "groups.mappings" "req" true "ctx" $))).res -}}
  {{- $groups_key_path := (fromYaml (include "inventory.config.resolve" (dict "path" "groups.key.path" "req" true "ctx" $))).res -}}
  {{- $groups := (fromYaml (include "lib.utils.dicts.lookup" (dict "data" $ "path" $groups_key_path "required" true))).res }}
  {{- if not $groups -}}
    {{- if (include "lib.utils.lists.hasValueByKey" (dict "list" $groups_base "value" "true" "key" "default")) -}}
      {{- $default_role := (fromYaml (include "lib.utils.lists.getValueByKey" (dict "list" $groups_base "value" "true" "key" "default"))).name -}}
      {{- $groups = $default_role -}}
    {{- else -}}
      {{- include "inventory.helpers.fail" "No roles given and no default role assigned" -}}
    {{- end -}}
  {{- end -}}
  {{- if (kindIs "string" $groups) -}}
    {{ $groups = list $groups }}
  {{- end -}}
  {{- $resv_cpts := list -}}
  {{- $resv_roles := list -}}
  {{- range $groups -}}
    {{- $resolved_role := fromYaml (include "inventory.groups.resolve" (dict "role" . "roles" $groups_base "ctx" $)) }}
    {{- $resv_cpts = concat $resv_cpts $resolved_role.cpts -}}
    {{- $resv_roles = concat $resv_roles $resolved_role.roles -}}
  {{- end -}}
  {{- $resv_cpts = $resv_cpts | uniq | compact -}}
  {{- $resv_roles = $resv_roles | uniq | compact -}}
  {{- printf "%s" (toYaml (dict "groups" $resv_roles "cpts" $resv_cpts "values" dict)) -}}
{{- end }}