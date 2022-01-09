{{/* Path <Template> 

  Returns the Path in a normalized format

  params <dict>:
    cond <string> Required: Condition Name
    path <string> Required: Condition Path
    ctx <dict> Required: Global Context

  returns <string>: Formatted Condition Path

*/}}
{{- define "inventory.conditions.func.path" -}}
  {{- if and $.cond $.path $.ctx -}}
    {{- $base_directory := (fromYaml (include "inventory.config.func.resolve" (dict "path" (include "inventory.conditions.defaults.inv_dir" $.ctx) "req" true "ctx" $.ctx))).res -}}
    {{- $base_path := (include "inventory.helpers.trailingPath" $.path) -}}
    {{- if $base_directory -}}
      {{- $base_path = (printf "%s/%s" (include "inventory.helpers.trailingPath" $base_directory | trimSuffix "/") $base_path) -}}
    {{- end -}}
    {{/* Full Path (Caputre if cond is only / -> allow root */}}
    {{- $path := "" -}}
    {{- $cond := ($.cond | trimAll "/") -}}
    {{- if $cond -}}
      {{- $path = (printf "%s/%s" ($base_path | trimSuffix "/") $cond) -}}
    {{- else -}}
      {{- $path = (printf "%s" ($base_path | trimSuffix "/")) -}}
    {{- end -}}
    {{/* Append Suffix if given */}}
    {{- if $.suffix -}}
      {{- $path = (printf "%s/%s" $path ($.suffix | trimAll "/")) -}}
    {{- end -}}
    {{- printf "%s/" $path -}}
  {{- else -}}
    {{- include "lib.utils.errors.params" (dict "tpl" "inventory.conditions.func.resolve" "params" (list "cond" "path" "ctx")) -}}
  {{- end -}}
{{- end -}}