{{/* Resolve <Template>

  Resolves Dropins with all their properties based on a given path. 
  The Dropins that matched may return data which is available for the file.

  params <dict>: 
    path: Required <string> Path to match
    ctx: Required <dict> Global context

  returns <dict>:
    patterns: <list> All patterns that matched
    data: <dict> Combined data of all data field and templates of dropins that matched
    lookup: <list> All considered templates
    templates: <list> All executed templates
    errors: <list> Errors encoutered during templating

*/}}
{{- define "inventory.dropins.func.resolve" -}}
  {{- $return :=  dict "patterns" list "data" dict "templates" list "lookup" list "errors" list -}}
  {{- if and $.path $.ctx -}}

    {{/* Variables */}}
    {{- $path := $.path -}}

    {{/* Get All Dropins */}}
    {{- $dropins := fromYaml (include "inventory.dropins.func.get" $.ctx) -}}
    {{- if $dropins -}}

      {{/* Error Redirect */}}
      {{- with $dropins.errors -}}
        {{- $_ := set $return "errors" (concat $return.errors .) -}}
      {{- end -}}

      {{/* When any valid Dropin returned */}}
      {{- if $dropins.dropins -}}
        {{- range $dropin := $dropins.dropins -}}

          {{/* Convert Patterns to Slice */}}
          {{- if not (kindIs "slice" $dropin.patterns) -}}
            {{- $_ := set $dropin "patterns" (list $dropin.patterns) -}}
          {{- end -}}

          {{/* Check if any pattern matches the fiven path */}}
          {{- range $pattern := $dropin.patterns -}}

            {{/* Matches Path */}}
            {{- if (regexMatch $pattern $path) -}}

              {{/* If Dropin has Data */}}
              {{- with $dropin.data -}}
                {{- $_ := set $return "data" (mergeOverwrite $return.data .) -}}
              {{- end -}}  

              {{/* If Dropin has Template */}}
              {{- if $dropin.tpls -}}

                {{/* Get Template Path if present */}}
                {{- $tpl_dir := (fromYaml (include "inventory.config.func.resolve" (dict "path" (include "inventory.dropins.defaults.tpls_dir" $.ctx) "ctx" $.ctx))).res -}}
                {{- $tpls := list -}}

                {{/* Evaluate all Template Paths */}}
                {{- range $t := $dropin.tpls -}}

                  {{/* Add Directory if present */}}
                  {{- if $tpl_dir -}}
                    {{- $t = printf "%s/%s" ($tpl_dir | trimSuffix "/") ($t | trimPrefix "/") -}}
                  {{- end -}}
 
                  {{/* Template Lookups */}}
                  {{- $_ := set $return "lookup" (append $return.lookup $t) -}}
                  
                  {{/* Check for files */}}
                  {{- range $path, $_ :=  $.ctx.Files -}}
                    {{- if (regexMatch $t $path) -}}
                      {{- $tpls = (append $tpls $path | uniq) -}}
                    {{- end -}}
                  {{ end -}}

                {{- end -}}
                
                {{/* Iterate over templates */}}
                {{- range $tpl_file := $tpls -}}

                  {{/* Parse given Template */}}
                  {{- $parsed_tpl := fromYaml (include "inventory.render.func.files.parse" (dict "parse" (dict "file" $tpl_file) "ctx" $.ctx)) -}}
  
                  {{/* Error Redirect */}}
                  {{- if $parsed_tpl.errors -}}
                    {{- $_ := set $return "errors" (concat $return.errors $parsed_tpl.errors) -}}
                  {{- else -}}
  
                    {{/* Succesful Template */}}
                    {{- if $parsed_tpl.content -}}

                      {{/* Add Template as succesful */}}
                      {{- $_ := set $return "templates" (append $return.templates $tpl_file) -}}
                      
                      {{/* Redirect Content */}}
                      {{- $_ := set $return "data" (mergeOverwrite $return.data $parsed_tpl.content) -}}

                    {{- end -}}
                  {{- end -}}
  
                {{- end -}}
              {{- end -}}
                
              {{/* Always add pattern as match */}}
              {{- $_ := set $return "patterns" (append $return.patterns $pattern) -}}

            {{- end -}}
          {{- end -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}

    {{/* Return */}}
    {{- printf "%s" (toYaml $return) -}}
  
  {{- else -}}
    {{- include "lib.utils.errors.params" (dict "tpl" "inventory.dropins.resolve" "params" (list "path" "ctx")) -}}
  {{- end -}}
{{- end -}}