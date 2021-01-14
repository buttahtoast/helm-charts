
{{/*
  Tavern - Test Directory
*/}}
{{- define "tavern.test_directory" -}}
{{ .Values.tavern.test_directory | trimSuffix "/" }}
{{- end -}}

{{/*
  Tavern - Environment Variables
*/}}
{{- define "tavern.environment" -}}
  {{- if $.Values.tavern.debug }}
- name: "DEBUG"
  value: "true"
  {{- end }}
- name: "TEST_DIRECTORY"
  value: {{ include "tavern.test_directory" $ }}
  {{- if $.Values.environment -}}
    {{- toYaml $.Values.environment | nindent 0 -}}
  {{- end }}
{{- end }}


{{/*
  Tavern - Check for Tests
*/}}
{{- define "tavern.has.tests" -}}
  {{- $tavern_tests := (fromYaml (include "tavern.tests" $)) -}}
  {{- if not (empty $tavern_tests.tests) -}}
    {{- true -}}
  {{- end -}}
{{- end }}


{{/*
  Tavern - Test Suites
*/}}
{{- define "tavern.tests" -}}
  {{- if and $.Values.tests (kindIs "slice" $.Values.tests) }}
    {{- $tests := list }}
    {{- range $.Values.tests }}
      {{- if .name }}
        {{- $tavern_test := . }}
        {{ $_ := set $tavern_test "name" (include "lib.utils.strings.toDns1123" .name) }}
        {{- if and .vanilla .test }}
          {{- $_ := set $tavern_test "test" .test }}
        {{- else }}
          {{- $t_values := dict }}
          {{- $g_stages := list }}
          {{- if .test }}
            {{- $_ := set $tavern_test "test" (fromYaml (include "lib.utils.strings.template" (dict "value" .test "extraValues" .values "extraValuesKey" "tavern" "context" $))) }}
          {{- else }}
            {{- $_ := set $tavern_test "test" dict -}}
          {{- end }}
          {{- if .template }}
            {{- if not (include "lib.utils.lists.hasValueByKey" (dict "list" $.Values.testTemplates "value" .template)) }}
              {{- fail (cat "Test Suite Template" (.template | squote) "not found") }}
            {{- else }}
              {{- $l_test_template := (fromYaml (include "lib.utils.lists.getValueByKey" (dict "list" $.Values.testTemplates "value" .template))) }}
              {{- $t_values = merge (default dict $l_test_template.values) (default dict .values) }}
              {{- $test_template := (fromYaml (include "lib.utils.strings.template" (dict "value" (default dict $l_test_template.template) "extraValues" $t_values "extraValuesKey" "tavern" "context" $))) }}
              {{- $g_stages = (fromYaml (include "lib.utils.lists.mergeListOnKey" (dict "source" $test_template.stages "target" (default dict $tavern_test.test.stages) "parentKey" "stages"))) }}
              {{- $_ := set $tavern_test "test" (mergeOverwrite $test_template (fromYaml (include "lib.utils.strings.template" (dict "value" .test "extraValues" $t_values "extraValuesKey" "tavern"  "context" $)))) }}
            {{- end }}
          {{- end }}
          {{- $_ := set $tavern_test.test "test_name" .name }}
          {{- $_S := (default . $g_stages) }}
          {{- if and $_S.stages (kindIs "slice" $_S.stages) }}
            {{- $stages := list }}
            {{- range $_S.stages }}
              {{- if .name }}
                {{- if .template }}
                  {{- if not (include "lib.utils.lists.hasValueByKey" (dict "list" $.Values.stageTemplates "value" .template)) }}
                    {{- fail (cat "Test Stage Template" (.template | squote) "not found") }}
                  {{- else }}
                    {{- $l_stage_template := (fromYaml (include "lib.utils.lists.getValueByKey" (dict "list" $.Values.stageTemplates "value" .template))) }}
                    {{- $l_values := merge $t_values (default dict $l_stage_template.values) (default dict .values) }}
                    {{- if (kindIs "string" $l_stage_template.template) }}
                      {{- $stage_template := (fromYaml (include "lib.utils.strings.template" (dict "value" $l_stage_template.template "extraValues" $l_values "extraValuesKey" "tavern" "context" $))) }}
                      {{- $stage := mergeOverwrite $stage_template (fromYaml (include "lib.utils.strings.template" (dict "value" (default dict .stage) "extraValues" $l_values "extraValuesKey" "tavern" "context" $))) }}
                      {{- $_ := set $stage "name" .name }}
                      {{- $stages = append $stages $stage }}
                    {{- end }}
                  {{- end }}
                {{- else }}
                  {{- if .stage }}
                    {{- $_ := set .stage "name" .name }}
                    {{- $stages = append $stages .stage }}
                  {{- end }}
                {{- end }}
              {{- end }}
            {{- end }}
            {{- $_ := set $tavern_test.test "stages" $stages }}
          {{- end }}
        {{- end }}
        {{- $tests = append $tests $tavern_test }}
      {{- end }}
    {{- end }}
tests: {{- toYaml $tests | nindent 2 }}
  {{- end }}
{{- end -}}
