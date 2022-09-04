{{/*
  HasValueByKey <Template>
*/}}
{{- define "lib.utils.lists.hasValueByKey" -}}
  {{- if .value }}
    {{- if .list }}
      {{- $key := default "name" .key }}
      {{- if (kindIs "slice" .list) }}
        {{- range .list }}
          {{- if . }}
            {{- if eq (get . $key) $.value -}}
              {{- true -}}
            {{- end }}
          {{- end }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end -}}

{{/*
  GetValueByKey <Template>
*/}}
{{- define "lib.utils.lists.getValueByKey" -}}
  {{- if and .list .value }}
    {{- if .list }}
      {{- $key := default "name" .key }}
      {{- if (kindIs "slice" .list) }}
        {{- range .list }}
          {{- if . }}
            {{- if eq (get . $key) $.value -}}
              {{- toYaml . | indent 0 }}
            {{- end }}
          {{- end }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end -}}

{{/*
  MergeList <Template>
*/}}
{{- define "lib.utils.lists.mergeList" -}}
    {{- $mergedList := (concat (default list (index . 0)) (default list (index . 1)) | uniq) -}}
    {{- if gt (len $mergedList) 0 }}
        {{- toYaml $mergedList | indent 0 }}
    {{- end }}
{{- end -}}

{{/*
  MergeListOnKey <Template>
*/}}
{{- define "lib.utils.lists.mergeListOnKey" -}}
  {{- if and (and .source (kindIs "slice" .source)) (and .target (kindIs "slice" .target)) }}
    {{- $cache := dict "output" list "input" (dict "onKey" (default "name" .key) "refList" .source "targetList" .target) "keys" (dict "allyKeys" list "refKeyList" list "targetKeyList" list "overlappingKeyList" list) "lists" (dict "overlappingItems" list "refListFilter" list "targetListFilter" list)}}
    {{- range $cache.input.refList }}
      {{- if (hasKey . $cache.input.onKey) }}
        {{- $_ := set $cache.keys "refKeyList" (append $cache.keys.refKeyList (get . $cache.input.onKey)) }}
      {{- end }}
    {{- end }}
    {{- range $cache.input.targetList  }}
      {{- if (hasKey . $cache.input.onKey) }}
        {{- $_ := set $cache.keys "targetKeyList" (append $cache.keys.targetKeyList (get . $cache.input.onKey)) }}
      {{- end }}
    {{- end }}
    {{- $_ := set $cache.keys "allKeys" (concat $cache.keys.refKeyList $cache.keys.targetKeyList | uniq) }}
    {{- if $cache.keys.allKeys }}
      {{- range $cache.keys.allKeys }}
        {{- if and (has . $cache.keys.refKeyList) (has . $cache.keys.targetKeyList) }}
          {{- $_ := set $cache.keys "overlappingKeyList" (append $cache.keys.overlappingKeyList . | uniq) }}
        {{- end }}
      {{- end }}
      {{- if $cache.keys.overlappingKeyList }}
        {{- range $cache.keys.overlappingKeyList }}
          {{- $_ := set $cache.lists "overlappingItems" (append $cache.lists.overlappingItems (merge (fromYaml (include "lib.utils.lists.getValueByKey" (dict "list" $cache.input.refList "value" .))) (fromYaml (include "lib.utils.lists.getValueByKey" (dict "list" $cache.input.targetList "value" .))))) }}
        {{- end }}
        {{- range $cache.input.refList }}
          {{- if not (has (get . $cache.input.onKey) $cache.keys.overlappingKeyList) }}
            {{- $_ := set $cache.lists "refListFilter" (append $cache.lists.refListFilter (fromYaml (include "lib.utils.lists.getValueByKey" (dict "list" $cache.input.refList "value" (get . $cache.input.onKey))))) }}
          {{- end }}
        {{- end }}
        {{- range $cache.input.targetList }}
          {{- if not (has (get . $cache.input.onKey) $cache.keys.overlappingKeyList) }}
            {{- $_ := set $cache.lists "targetListFilter" (append $cache.lists.targetListFilter (fromYaml (include "lib.utils.lists.getValueByKey" (dict "list" $cache.input.targetList "value" (get . $cache.input.onKey))))) }}
          {{- end }}
        {{- end }}
        {{- $_ := set $cache "output" (concat $cache.lists.refListFilter $cache.lists.targetListFilter $cache.lists.overlappingItems) }}
      {{- else }}
        {{- $_ := set $cache "output" (concat $cache.input.refList $cache.input.targetList) }}
      {{- end }}
      {{- if .parentKey }}
        {{- .parentKey | nindent 0 }}: {{- toYaml $cache.output | nindent 2 }}
      {{- else }}
        {{- toYaml $cache.output | nindent 0 }}
      {{- end }}
    {{- end }}
  {{- else }}
    {{- if and (and .source (kindIs "slice" .source)) }}
      {{- if .parentKey }}
        {{- .parentKey | nindent 0 }}: {{- toYaml .source | nindent 2 }}
      {{- else }}
        {{- toYaml .source | nindent 0 }}
      {{- end }}
    {{- else }}
      {{- if .parentKey }}
        {{- .parentKey | nindent 0 }}: {{- toYaml .target | nindent 2 }}
      {{- else }}
        {{- toYaml .target | nindent 0 }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}


{{/*
  ExceptionList <Template>
*/}}
{{- define "lib.utils.lists.exceptionList" -}}
  {{- if and .list (kindIs "slice" .list) }}
    {{- if .exceptions }}
      {{- $key := (default "name" .key) }}
      {{- $context := .context }}
      {{- $filteredList := list }}
      {{- $exceptionList := list }}
      {{- if kindIs "slice" .exceptions }}
        {{- $exceptionList = .exceptions }}
      {{- else }}
        {{- $exceptionList = (splitList " " .exceptions) }}
      {{- end }}
      {{- range .list  }}
        {{- if kindIs "map" . }}
          {{- if not (has (get . $key) $exceptionList) -}}
            {{- $filteredList = append $filteredList . -}}
          {{- end }}
        {{- else }}
          {{- $filteredList = append $filteredList . -}}
        {{- end }}
      {{- end }}
      {{- toYaml $filteredList  | indent 0 }}
    {{- else }}
      {{- toYaml list | nindent 0 }}
    {{- end }}
  {{- end }}
{{- end -}}


{{/*
  Merge <Template>
*/}}
{{- define "lib.utils.lists.merge" -}}
  {{/* Merge Options */}}
  {{- $inject_key := (include "lib.utils.lists.merge.int.inject_key" $) -}}

  {{- if and (kindIs "slice" $.base) (kindIs "slice" $.data) -}}

    {{/* Evaluate Merge Key */}}
    {{- $merge_key := "name" -}}

    {{/* Validate MergeKey Property on Data */}}
    {{- range $e := $.data -}}
      {{- if (kindIs "string" $e) -}}
        {{/* Match on Expression ((*)) */}}
        {{- $merge_exp := regexFind "\\(\\(.*\\)\\)" $e  -}}
        {{- if $merge_exp -}}

          {{/* Format Merge Key (Without Expression) */}}
          {{- $f_key := ($merge_exp | nospace | replace "(" "" | replace ")" "" ) -}}
          {{- if $f_key -}}
            {{- $merge_key = $f_key -}}
          {{- end -}}
        {{- end -}}

        {{/* Remove Key Anyway */}}
        {{- $_ := set $ "data" (without (get $ "data") $merge_exp) -}}
      {{- end -}}
    {{- end -}}

    {{/* Match Tracker */}}
    {{- $unmatched_base := list -}}
    {{- $unmatched_data := $.data -}}

    {{/* Range Over Base (This way we can remove unmatched entries) */}}
    {{- range $i, $base_leaf := $.base -}}
      {{- $merged := 1 -}}
      {{- if (kindIs "map" $base_leaf) -}}
        {{/* Data Leafs */}}
        {{- range $leaf := $.data -}}
          {{- if (kindIs "map" $leaf) -}}
            {{/* Validate If Merge Key identical */}}
            {{- if eq ((get $leaf $merge_key) | toString) ((get $base_leaf $merge_key) | toString) -}}
  
              {{/* Remove Leaf on Data */}}
              {{- $unmatched_data = without $unmatched_data $leaf -}}
              {{- $merged = 0 -}}
  
              {{/* Recursion (Handles Dict Types as well) */}}
              {{- include "lib.utils.dicts.merge" (dict "base" $base_leaf "data" $leaf "ctx" $.ctx) -}}
  
            {{- end -}}
          {{- end -}}
        {{- end -}}
      {{- end -}}

      {{/* Append Unmerged Leafs to Unmatched Base */}}
      {{- if $merged -}}
        {{- $unmatched_base = append $unmatched_base $base_leaf -}}
      {{- end -}}
    {{- end -}}

    {{/* Remove Unmatched From Base List */}}
    {{- range $u := $unmatched_base -}}
      {{- $_ := set $ "base" (without (get $ "base") $u) -}}
    {{- end -}}

    {{/* Add Unmatched from Data */}}
    {{- range $u := $unmatched_data -}}
      {{- $_ := set $ "base" (append (get $ "base") $u) -}}
    {{- end -}}


    {{/* Data Injector */}}
    {{- $injected := 0 -}}
    {{- range $i, $base_leaf := $.base -}}
      {{- if and (kindIs "string" $base_leaf) (not $injected)  -}}
        {{- if (eq ($base_leaf | lower) $inject_key) -}}
    
          {{/* Inject on Unmatched Base Data */}}
          {{- if $unmatched_base -}}
            {{- $tmp := list -}}
            {{/* First Entry */}}
            {{- if (eq $i 0) -}}
              {{- $tmp = concat $unmatched_base $.base -}}
            {{/* Inject Within List */}}
            {{- else -}}
              {{- $partial_list := slice $.base 0 $i -}}
              {{- $partial_list = concat $partial_list $unmatched_base -}}
              {{- $partial_list = concat $partial_list (slice $.base $i) -}}
              {{- $tmp = $partial_list -}}
            {{- end -}}
  
            {{/* Update Inject Tracker */}}
            {{- $injected = 1 -}}
  
            {{/* Redirect Injected Slice */}}
            {{- $_ := set $ "base" $tmp -}}
    
          {{- end -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
    
    {{/* Remove Inject Key Anyway (Must Remove on Both Dicts) */}}
    {{- $_ := set $ "data" (without (get $ "data") $inject_key) -}}
    {{- $_ := set $ "base" (without (get $ "base") $inject_key) -}}

  {{- end -}}
{{- end -}}

{{/*
  Inject Key <Internal Template>
*/}}
{{- define "lib.utils.lists.merge.int.inject_key" -}}
__inject__
{{- end -}}