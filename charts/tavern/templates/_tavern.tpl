{{/*
  Check if any Tavern Test were defined
*/}}
{{- define "tavern.has.tests" -}}
  {{- $tavern_tests := (fromYaml (include "tavern.tests" $)) -}}
  {{- if not (empty $tavern_tests.tests) -}}
    {{- true -}}
  {{- end -}}
{{- end }}







{{- define "tavern.tests" -}}
  {{- if and $.Values.tests (kindIs "slice" $.Values.tests) }}
    {{- $tests := list -}}
    {{- range $.Values.tests }}
      {{- if .name }}
        {{- $tavern_test := . }}
        {{ $_ := set $tavern_test "name" (include "lib.utils.toDns1123" .name) }}
        {{- $g_stages := list }}
        {{- if .test }}
          {{- $_ := set $tavern_test "test" (fromYaml (include "lib.utils.template" (dict "value" .test "extraValues" .values "extraValuesKey" "tavern" "context" $))) }}
        {{- end }}
        {{- if .template }}
          {{- if not (include "lib.utils.hasValueByKey" (dict "list" $.Values.testTemplates "value" .template)) }}
            {{- fail "Test Template '$template' not found" }}
          {{- else }}
            {{- $l_test_template := (fromYaml (include "lib.utils.getValueByKey" (dict "list" $.Values.testTemplates "value" .template))) }}
            {{- $l_values := merge (default dict $l_test_template.values) (default dict .values) }}
            {{- $test_template := (fromYaml (include "lib.utils.template" (dict "value" $l_test_template.template "extraValues" $l_values "extraValuesKey" "tavern" "context" $))) }}
            {{- $g_stages = (fromYaml (include "lib.utils.mergeListOnKey" (dict "source" $test_template.stages "target" $tavern_test.stages "parentKey" "stages"))) }}
            {{- $_ := set $tavern_test "test" (mergeOverwrite $test_template (fromYaml (include "lib.utils.template" (dict "value" .test "extraValues" $l_values "extraValuesKey" "tavern"  "context" $)))) }}
          {{- end }}
        {{- end }}
        {{- $_ := set $tavern_test.test "test_name" .name }}


        {{- $_S := (default . $g_stages) }}
        {{- if and $_S.stages (kindIs "slice" $_S.stages) }}
          {{- $stages := list }}
          {{- range $_S.stages }}
            {{- if .name }}
              {{- if .template }}
                {{- if not (include "lib.utils.hasValueByKey" (dict "list" $.Values.stageTemplates "value" .template)) }}
                  {{- fail "Stage Template '$template' not found" }}
                {{- else }}
                  {{- $l_stage_template := (fromYaml (include "lib.utils.getValueByKey" (dict "list" $.Values.stageTemplates "value" .template))) }}
                  {{- $l_values := merge (default dict $l_stage_template.values) (default dict .values) }}
                  {{- $stage_template := (fromYaml (include "lib.utils.template" (dict "value" $l_stage_template.template "extraValues" $l_values "extraValuesKey" "tavern" "context" $))) }}
                  {{- $stage := mergeOverwrite $stage_template (fromYaml (include "lib.utils.template" (dict "value" (default dict .stage) "extraValues" $l_values "extraValuesKey" "tavern" "context" $))) }}
                  {{- $_ := set $stage "name" .name }}
                  {{- $stages = append $stages $stage }}
                {{- end }}
              {{- else }}
                {{- if .stage }}
                  {{- $stages = append $stages .stage }}
                {{- end }}
              {{- end }}
            {{- end }}
          {{- end }}
          {{- $_ := set $tavern_test.test "stages" $stages }}
        {{- end }}
        {{- $tests = append $tests $tavern_test }}
      {{- end }}
    {{- end }}
tests: {{- toYaml $tests | nindent 2 }}
  {{- end }}
{{- end -}}
