{{/*
Values Appender

  This function allows to append a given struct to a new parent key and returns the resulting YAML structure.

Arguments

  If an as required marked argument is missing, the template engine will intentionaly.

  * .key - The new parent key for the given key structure (Optional, Defaults to "Values" key)
  * .append - Key structure you want to append (Optional, Defaults to function Root Context)

Returns

  YAML Structure

Usage:

  {{- include "bedag-lib.util.valuesAppend" (fromYaml (include "bedag-lib.util.mergeYamlFiles" (dict "path" "myFiles/**.yaml" "context" $))) }}

*/}}
{{- define "lib.utils.valuesAppend" -}}
  {{- $baseDict := dict -}}
  {{- $_ := set $baseDict (default .key "Values") (default . .append) -}}
  {{- toYaml $_ | indent 0 }}
{{- end -}}


{{/*
YAML Structure Printer

  This function allows to append a given struct to a new parent key and returns the resulting YAML structure.

Arguments

  If an as required marked argument is missing, the template engine will intentionaly.

  * .structure - Enter the structure seperated by '.' (Required)
      E.g. the input of "Values.sub.key" will result in the output of:
        Values:
          sub:
            key:

  * .data - Data which will be inserted below the structure (Optional)

Returns

  String

Usage:

  {{- include "bedag-lib.util.printYAMLStructure" (dict "structure" $path "data" "My Data Structure") }}

*/}}
{{- define "lib.utils.printYAMLStructure" -}}
  {{ $structure := trimSuffix "." .structure }}
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
{{- end -}}
