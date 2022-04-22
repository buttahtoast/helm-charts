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
      {{- $renders := (fromYaml (include "inventory.postrenders.func.get" (dict "ctx" $.ctx))).renders -}}

      {{/* Add Post-Renderers as Debug */}}
      {{- if (include "inventory.entrypoint.func.debug" $.ctx) -}}
        {{- $_ := set $.file "renderers" $renders -}}
      {{- end -}}

      {{/* Execute Renderers */}}
      {{- $content_buff := $.file.content -}}
      {{- range $ren := $renders -}}

        {{/* Execute Renderer */}}
        {{- $postrender_result_raw := include $ren (dict "content" $content_buff "File" (omit $.file "content") (default "inv" $.extra_ctx_key) (default dict $.extra_ctx) "ctx" $context) -}}
        {{- $postrender_result := fromYaml ($postrender_result_raw) -}}

        {{- if not (include "lib.utils.errors.unmarshalingError" $postrender_result) -}}

          {{/* Debug Output */}}
          {{- if $postrender_result.debug -}}
            {{- $_ := set $.file "debug" (append $.file.debug (dict "post-renderer" $ren "debug" $postrender_result.debug)) -}}
          {{- end -}}
  
          {{/* If PostRenderer returns Errors */}}
          {{- if $postrender_result.errors -}}
            {{- $_ := set $.file "errors" (concat $.file.errors $postrender_result.errors) -}}
          {{- else -}}

            {{/* Use content */}}
            {{- if $postrender_result.content -}}
              {{- if (kindIs "map" $postrender_result.content) -}}
                {{- $content_buff = $postrender_result.content -}}
              {{- else -}}
                {{- $_ := set $.file "errors" (append $.file.errors (dict "error" (printf "Content is kind '%s' but should be 'map'" (kindOf $postrender_result.content)) "post-renderer" $ren "trace" $postrender_result.content)) -}}
              {{- end -}}
            {{- else -}}
              {{- if (include "inventory.entrypoint.func.debug" $.ctx) -}}
                {{- $_ := set $.file "debug" (append $.file.debug (dict "post-renderer" $ren "debug" "Empty Content")) -}}
              {{- end -}}
            {{- end -}}
          {{- end -}}

        {{- else -}}
          {{- $_ := set $.file "errors" (append $.file.errors (dict "error" (cat "Encountered Error during postrendering" $postrender_result.Error) "post-renderer" $ren "trace" $postrender_result_raw)) -}}
        {{- end -}}
      {{- end -}}
      {{- $_ := set $.file "content" $content_buff -}}
    {{- end -}}

  {{- end -}}
{{- end -}}