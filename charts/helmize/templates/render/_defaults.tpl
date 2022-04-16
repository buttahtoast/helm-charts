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


{{/* Match (File Configuration Type) <Template> 

   Match Strategy Key

*/}}
{{- define "inventory.render.defaults.file_cfg.match" -}}
match_ids
{{- end -}}

{{/* No Match (File Configuration Type) <Template> 

   Match Strategy Key

*/}}
{{- define "inventory.render.defaults.file_cfg.no_match" -}}
no_match
{{- end -}}

{{/* Multiple filename id (File Configuration Type) <Template> 

   Allow multiple resources from one file to use the filename

*/}}
{{- define "inventory.render.defaults.file_cfg.multi_filename" -}}
multiple_filename_id
{{- end -}}

