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
    mergeOn


*/}}
{{- define "lib.utils.dicts.merge" -}}
  {{- $base := $.base -}}
  {{- range $key, $data := $.data -}}

    {{/* Overwrite if not set */}}
    {{- $base_data := (get $base $key) -}}
    {{- if $base_data -}}

      {{/* if types don't match the key is overwritten */}}
      {{- if (eq (kindOf $data) (kindOf $base_data)) -}}
        {{/* Compare Types */}}
        {{- if (kindIs "map" $data) -}}

          {{/* Recursive Call */}}
          {{- include "lib.utils.dicts.merge" (dict "base" $base_data "data" $data "ctx" $.ctx) -}}
        
        {{/* Handle List merges */}}
        {{- else if (kindIs "slice" $data) -}}
            {{- $unmatched_base := $base_data -}}
            {{- $tmp_list := $data -}}
            {{- $tmp_list = append $tmp_list "WAS_HERE" -}}

            {{/* Iterate on Key */}}
            {{- $merge_key := "name" -}}
            {{- range $leaf := $data -}}

              {{- $merged := 0 -}}

              {{/* Nested Merge only when Leaf is map */}}
              {{- if (kindIs "map" $leaf) -}}
                {{- if (get $leaf $merge_key) -}}
                  {{- range $i, $base_leaf := $base_data -}}
                    {{- if (get $base_leaf $merge_key) -}}
                      {{/* Validate if Key Same */}}
                      {{- if eq (get $leaf $merge_key) (get $base_leaf $merge_key) -}}

                        {{/* Unset in Base */}}
                        {{- $unmatched_base = without $unmatched_base $base_leaf -}}

                        {{/* Recursive Call */}}
                        {{- include "lib.utils.dicts.merge" (dict "base" $base_leaf "data" $leaf "ctx" $.ctx) -}}      

                      {{- end -}}
                    {{- end -}}
                  {{- end -}}
                {{- end -}}
              {{- end -}}
            {{- end -}}


            {{/* If the Unmatched From Base leaf, can be injected */}}
            {{- if $unmatched_base -}}
              {{- $matched := 0 -}}
              {{- range $i, $leaf := $tmp_list -}}
              
                {{/* Validate Type */}}
                {{- if and (kindIs "string" $leaf) -}}

                  {{/* Validate Append */}}
                  {{- $inject_key := "__inject__" -}}
                  {{- if (eq ($leaf | lower) $inject_key) -}}
                    
                    {{/* IF First Entry */}}
                    {{- if (eq $i 0) -}}
                      {{- $tmp_list = concat  $unmatched_base $tmp_list -}}

                    {{/* Inject Within List */}}
                    {{- else -}}
                      {{- $partial_list := slice $tmp_list 0 $i -}}
                      {{- $partial_list = concat $partial_list $unmatched_base -}}
                      {{- $partial_list = concat $partial_list (slice $tmp_list $i) -}}
                      {{- $tmp_list = $partial_list -}}
                    {{- end -}}

                    {{/* Split Array */}}
                    {{- $tmp_list = without $tmp_list $inject_key -}}

                  {{- end -}}
                {{- end -}}
              {{- end -}}
            {{- end -}}

            {{/* Redirect to Base */}}
            {{- $_ := set $base $key $tmp_list -}}
         
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



