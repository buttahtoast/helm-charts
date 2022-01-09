{{/* Render <Template> 

  Allows to run postrenderes for each file on a component. The components which are executed are 
  used from the "inventory.postrenders.includes" template.

  params <dict>: 
    file: <dict> Train File declaration
    extra_ctx: Optional <dict> Extra variables that are available during templating
    extra_ctx_key: Optional <string> Under which top key the given extra variables are publishes. Defaults to 'inv'
    ctx: <dict> Global Context

  returns  <dict>: Modified component


  PostRenderers:

    Each PostRenderer gets the following two arguments:
    
      File <dict>: File parameters
      content <dict>: Content of the current iterated file
      context <dict>: Global Context
  
    The post Renderer must supply a valid dictionary which can be formatted from yaml. It's your responsability to test
    self added postrenderers. The postrenderer can overwrite the entire content.
    Each postrenderer must return the following:
  
      content <dict>
      errors <slice>
  
    If any errors are returned the content is not considered and the errors will be returned. 
    Is the content empty, it won't be considered as well.

*/}}
{{- define "inventory.postrenders.func.execute" -}}
  {{- $return := dict "content" dict "errors" list -}}
  {{- if and $.file $.ctx -}}

    {{/* Extra Context */}}
    {{- $context := $.ctx -}}
    {{- if and $.extra_ctx (kindIs "map" $.extra_ctx) -}}
      {{- $_ := set $context (default "inv" $.extra_ctx_key) $.extra_ctx -}}
    {{- else -}}
      {{- $_ := set $context (default "inv" $.extra_ctx_key) dict -}}
    {{- end -}}

    {{/* File has Content */}}
    {{- if $.file.content -}}

      {{/* Load Renderers */}}
      {{- $raw_renders := (include "inventory.postrenders.includes" $.ctx) -}}
      {{- $renders := splitList "\n" $raw_renders -}}

      {{/* Execute Renderers */}}
      {{- $content_buff := $.file.content -}}
      {{- range $renders -}}
        {{- $postrender_result_raw := include . (dict "content" $content_buff "File" (omit $.file "content") (default "inv" $.extra_ctx_key) (default dict $.extra_ctx) "ctx" $context) -}}
        {{- $postrender_result := fromYaml ($postrender_result_raw) -}}
        {{- if not (include "lib.utils.errors.unmarshalingError" $postrender_result) -}}

          {{/* If PostRenderer returns Errors */}}
          {{- if $postrender_result.errors -}}
            {{- $_ := set $return "errors" (concat $return.errors $postrender_result.errors) -}}
          {{- else -}}
            {{/* Merge Content */}}
            {{- if $postrender_result.content -}}
              {{- $content_buff = $postrender_result.content -}}
            {{- end -}}
          {{- end -}}

        {{- else -}}
          {{- $_ := set $return "errors" (append $return.errors (dict "error" (cat "Encountered Error during postrendering" $postrender_result.Error) "renderer" . "trace" $postrender_result_raw)) -}}
        {{- end -}}
      {{- end -}}
      {{- $_ := set $return "content" $content_buff -}}
    {{- end -}}

    {{/* Return */}}
    {{- printf "%s" (toYaml $return) -}}

  {{- end -}}
{{- end -}}