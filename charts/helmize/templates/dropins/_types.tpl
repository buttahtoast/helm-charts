{{/* Dropin <Type>

  Defines the Type Definition for one Dropin Property
  
*/}}
{{- define "inventory.dropins.types.dropin" -}}
patterns:
  types: [ "string", "slice" ]
  required: true
data:
  types: [ "map" ]
tpls:
  types: [ "slice" ]  
{{- end -}}