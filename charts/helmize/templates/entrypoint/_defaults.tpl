{{/* Force Parameter <Template> 

  Default Configuration Key within configuration file for force option

*/}}
{{- define "inventory.entrypoint.defaults.force" -}}
force
{{- end -}}

{{/* Summary Parameter <Template> 

  Default Summary Values Key

*/}}
{{- define "inventory.entrypoint.defaults.summary_value" -}}
summary
{{- end -}}

{{/* Debug Parameter <Template> 

  Default Debug Values Key

*/}}
{{- define "inventory.entrypoint.defaults.debug_value" -}}
debug
{{- end -}}

{{/* Timestamps Parameter <Template> 

  Print Timestamps (For Benchmarking)

*/}}
{{- define "inventory.entrypoint.defaults.benchmark_value" -}}
benchmark
{{- end -}}

{{/* Merge Strategy <Template> 

  Default Configuration Key within configuration for render template declaration

*/}}
{{- define "inventory.entrypoint.defaults.render_template" -}}
render_template
{{- end -}}
