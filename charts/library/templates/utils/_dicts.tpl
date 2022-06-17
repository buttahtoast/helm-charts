{{/*
  ParentAppend <Template>
*/}}
{{- define "lib.utils.dicts.parentAppend" -}}
  {{- $baseDict := dict -}}
  {{- $_ := set $baseDict (default .key "Values") (default . .append) -}}
  {{- toYaml $_ | indent 0 }}
{{- end -}}


{{/*
  PrintYamlStructure <Template>
*/}}
{{- define "lib.utils.dicts.printYAMLStructure" -}}
  {{- if .structure }}
    {{ $structure := trimAll "." .structure }}
    {{- $i := 0 }}
    {{- if $structure }}
      {{- range (splitList "." $structure) }}
        {{- . | nindent (int $i) }}:
        {{- $i = add $i 2 }}
      {{- end }}
    {{- end }}
    {{- if .data }}
      {{- .data | nindent (int $i) }}
    {{- end }}
  {{- end }}
{{- end -}}


{{/*
  Lookup <Template>
*/}}
{{- define "lib.utils.dicts.lookup" -}}
  {{- $result := dict "res" "" -}}
  {{- $path := trimAll "." .path -}}
  {{- if and $path .data -}}
    {{- $buf := .data -}}
    {{- $miss := dict "state" false "path" -}}
    {{- range (splitList "." $path) }}
      {{- if eq $miss.state false -}}
        {{- if (hasKey $buf .) }}
          {{- $buf = get $buf . -}}
        {{- else -}}
          {{- $_ := set $miss "path" . -}}
          {{- $_ := set $miss "state" true -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
    {{- if eq $miss.state false -}}
      {{- printf "%s" (toYaml (dict "res" $buf)) -}}
    {{- else -}}
      {{- if eq (default false .required) true -}}
        {{ include "lib.utils.errors.fail" (cat "Missing path" $miss.path "for lookup" $path "in structure\n" (toYaml .data | nindent 0)) }}
      {{- else -}}
        {{- printf "%s" (toYaml $result) -}}
      {{- end -}}
    {{- end -}}
  {{- else -}}
    {{- printf "%s" (toYaml $result) -}}
  {{- end -}}
{{- end -}}


{{/*
  Unset <Template>
*/}}
{{- define "lib.utils.dicts.unset" -}}
  {{- $path := trimAll "." $.path -}}
  {{- if and $path $.data -}}
    {{- $buf := $.data -}}
    {{- $paths := (splitList "." $path) -}}
    {{- range $i, $p := $paths -}}
        {{- if (hasKey $buf .) }}
          {{- if eq (last $paths) . -}}
            {{- $_ := unset $buf . -}}
          {{- else -}}
            {{- $buf = get $buf . -}}
          {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
  Set <Template>
*/}}
{{- define "lib.utils.dicts.set" -}}
  {{- $path := trimAll "." .path -}}
  {{- if and $path $.data $.value -}}
    {{- $buf := .data -}}
    {{- $paths := (splitList "." $path) -}}
    {{- range $paths }}
      {{- if eq . (last $paths) -}}
        {{- $_ := set $buf . $.value -}}
      {{- else -}}
        {{- if not (hasKey $buf .) }}
          {{- $_ := set $buf . dict -}}
        {{- end -}}
        {{- $buf = get $buf . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}



{{/*
  Merge Nested Structures <Template>

    dict "" "2" "" 
    listBehavior: 
    injectKey


*/}}
{{- define "lib.utils.dicts.merge" -}}
  {{- $base := $.base -}}

  {{/* Merge Options */}}
  {{- $inject_key := default "__inject__" $.injectKey -}}

  {{/* Iterate over Keys */}}
  {{- range $key, $data := $.data -}}

    {{/* Overwrite if not set */}}
    {{- $base_data := (get $base $key) -}}
    {{- if $base_data -}}

      {{/* if types don't match the key is overwritten */}}
      {{- if (eq (kindOf $data) (kindOf $base_data)) -}}
        {{/* Compare Types */}}
        {{- if (kindIs "map" $data) -}}

          {{/* Recursive Call */}}
          {{- include "lib.utils.dicts.merge" (dict "base" $base_data "data" $data "injectKey" $inject_key "ctx" $.ctx) -}}
        
        {{/* Handle List merges */}}
        {{- else if (kindIs "slice" $data) -}}

            {{/* Need to dereference */}}
            {{- $unmatched_base := list -}}
            {{- $unmatched_data := $data -}}

            {{/* Evaluate Merge Key */}}
            {{- $merge_key := "name" -}}
            {{- range $u := $data -}}
              {{- if (kindIs "string" $u) -}}
                {{/* Match on Expression ((*)) */}}
                {{- $merge_exp := regexFind "\(\(.*\)\)" $u -}}
                {{- if $merge_exp -}}
                  {{- $_ := set $.data $key (without (get $data $key) $merge_exp) -}}
                {{- end -}}
              {{- end -}}
            {{- end -}}


            {{/* Range Over Base (This way we can remove unmatched entries) */}}
            {{- range $i, $base_leaf := $base_data -}}
              {{- $merged := 1 -}}

              {{- if (kindIs "map" $base_leaf) -}}

                {{- range $leaf := $data -}}
                  {{- if (kindIs "map" $leaf) -}}
                      {{/* Validate if Key Same */}}
                      {{- if eq (get $leaf $merge_key) (get $base_leaf $merge_key) -}}
  
                        {{/* Remove Leaf on Data */}}
                        {{- $unmatched_data = without $unmatched_data $leaf -}}
                        {{- $merged = 0 -}}
  
                        {{/* Recursion */}}
                        {{- include "lib.utils.dicts.merge" (dict "base" $base_leaf "data" $leaf "injectKey" $inject_key "ctx" $.ctx) -}}
  
                      {{- end -}}
                  {{- end -}}
                {{- end -}}
              {{- end -}}

              {{/* Append Unmerged Leafs to base */}}
              {{- if $merged -}}
                {{- $unmatched_base = append $unmatched_base $base_leaf -}}
              {{- end -}}
            {{- end -}}

            {{/* Remove Unmatched From Base List */}}
            {{- range $u := $unmatched_base -}}
              {{- $_ := set $base $key (without (get $base $key) $u) -}}
            {{- end -}}

            {{/* Add Unmatched from Data */}}
            {{- range $u := $unmatched_data -}}
              {{- $_ := set $base $key (append (get $base $key) $u) -}}
            {{- end -}}


            {{/* Data Injector */}}
            {{- if $unmatched_base -}}
              {{- range $i, $base_leaf := (get $base $key) -}}
                {{- if and (kindIs "string" $base_leaf) -}}
                  {{- $tmp := list -}}
                  {{- if (eq ($base_leaf | lower) $inject_key) -}}
                    {{/* First Entry */}}
                    {{- if (eq $i 0) -}}
                      {{- $tmp = concat $unmatched_base (get $base $key) -}}

                    {{/* Inject Within List */}}
                    {{- else -}}
                      {{- $partial_list := slice (get $base $key) 0 $i -}}
                      {{- $partial_list = concat $partial_list $unmatched_base -}}
                      {{- $partial_list = concat $partial_list (slice (get $base $key) $i) -}}
                      {{- $tmp = $partial_list -}}
                    {{- end -}}

                    {{/* Split Array */}}
                    {{- $_ := set $base $key (without $tmp $inject_key ) -}}

                  {{- end -}}
                {{- end -}}
              {{- end -}}
            {{- end -}}




            {{/* Redirect to Base
            {{- $data := without $data $leaf -}}
            {{- $_ := set $base $key $data -}}*/}}
         
        {{/* Redirect Data */}}
        {{- else -}}
          {{- $_ := set $base $key $data -}}
        {{- end -}}
      {{/* Overwrite */}}
      {{- else -}}
        {{- $_ := set $base $key $data -}}
      {{- end -}}
    {{/* Overwrite */}}
    {{- else -}}
      {{- $_ := set $base $key $data -}}
    {{- end -}}
  {{- end -}}
{{- end -}}



