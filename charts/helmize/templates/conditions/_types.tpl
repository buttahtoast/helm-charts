{{/* Condition <Type>

  Defines the Type Definition for one Condition Type
  
*/}}
{{- define "inventory.conditions.types.condition" -}}
name:
  types: [ "string" ]
  required: true
key:
  types: [ "string" ]
key_types:
  types: [ "slice" ]
  default: [ "string", "slice" ]
required:
  types: [ "int", "bool" ]
default:
  types: [ "string" ]
path:
  types: [ "string" ]
filter: 
  types: [ "string", "slice" ]
reverseFilter:
  types: [ "int", "bool" ]
allow_root:
  types: [ "int", "bool" ]     
{{- end -}}