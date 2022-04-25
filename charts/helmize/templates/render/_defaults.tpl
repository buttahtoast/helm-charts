{{/* Excludes <Template> 

  Default Configuration Key within configuration file for file exlusion option

*/}}
{{- define "inventory.render.defaults.file.excludes" -}}
file_excludes
{{- end -}}


{{/* Extensions <Template> 

  Default Configuration Key within configuration file for file extensions option

*/}}
{{- define "inventory.render.defaults.file.extensions" -}}
file_extensions
{{- end -}}


{{/* Merge Strategy <Template> 

  Default Configuration Key within configuration file for merge strategy option

*/}}
{{- define "inventory.render.defaults.file.merge_strategy" -}}
merge_strategy
{{- end -}}

{{/* Merge Strategy <Template> 

  Default Configuration Key within configuration for custom identifier evaluation

*/}}
{{- define "inventory.render.defaults.files.identifier_template" -}}
custom_identifier_template
{{- end -}}

{{/* Data Key <Template> 

  Key within Content which can innherit Data between all files

*/}}
{{- define "inventory.render.defaults.files.data_key" -}}
Data
{{- end -}}

{{/* File Configuration Key <Template> 

   Key within Files for file configuration

*/}}
{{- define "inventory.render.defaults.file_cfg.key" -}}
cfg
{{- end -}}

{{/* No Match (File Configuration Type) <Template> 

   Match Strategy Key

*/}}
{{- define "inventory.render.defaults.file_cfg.no_match" -}}
no_match
{{- end -}}


{{- define "inventory.render.defaults.file_cfg.expand" -}}
expand
{{- end -}}


{{- define "inventory.render.defaults.file_cfg.subpath" -}}
subpath
{{- end -}}

{{/* Render (File Configuration Type, Local) <Template> 

   Configure if a file should be rendered in the final output. Note that it will still show up in the Summary

*/}}
{{- define "inventory.render.defaults.file_cfg.render" -}}
render
{{- end -}}

{{/* Pattern (File Configuration Type, Local) <Template> 

   IDs are used as Patterns to match against other ids. If Enabled the file won't be added if nothing matches.

*/}}
{{- define "inventory.render.defaults.file_cfg.fork" -}}
fork
{{- end -}}

{{/* Pattern (File Configuration Type, Local) <Template> 

   IDs are used as Patterns to match against other ids. If Enabled the file won't be added if nothing matches.

*/}}
{{- define "inventory.render.defaults.file_cfg.pattern" -}}
pattern
{{- end -}}
