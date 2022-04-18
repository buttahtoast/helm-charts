{{/* Force <Template> 

  Default Configuration Key within configuration file for force option

*/}}
{{- define "inventory.entrypoint.defaults.force" -}}
force
{{- end -}}

{{/* Summary <Template> 

  Default Summary Values Key

*/}}
{{- define "inventory.entrypoint.defaults.summary_value" -}}
summary
{{- end -}}

{{/* Debug <Template> 

  Default Debug Values Key

*/}}
{{- define "inventory.entrypoint.defaults.debug_value" -}}
debug
{{- end -}}

{{/* Timestamps <Template> 

  Print Timestamps (For Benchmarking)

*/}}
{{- define "inventory.entrypoint.defaults.benchmark_value" -}}
benchmark
{{- end -}}
