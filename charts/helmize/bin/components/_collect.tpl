{{/* 
  Collects a summary of all given components 

*/}}
{{- define "inventory.components.collect" -}}
  {{- if and $.cpts $.ctx -}}
    {{- $return := dict "components" list "errors" list -}}
    {{/*Initial Iteration for all components */}}
    {{- $component_train := list -}}
    {{- $components_conf := (fromYaml (include "inventory.config.resolve" (dict "path" "components" "ctx" $.ctx))).res -}}
    {{- range $.cpts -}}
      {{/* Single Component Struct */}}
      {{- $component := dict "name" . "errors" list "files" dict "values" -}}
      {{/* Attempt to resolve component configuration */}}
      {{- if $components_conf -}}
        {{- if (include "lib.utils.lists.hasValueByKey" (dict "list" $components_conf "value" . "key" "name")) -}}
          {{- $conf := fromYaml (include "lib.utils.lists.getValueByKey" (dict "list" $components_conf "value" . "key" "name")) -}}
          {{/* Remove reserved fields */}}
          {{- $reserved := list "files" "errors" "meta" -}}
          {{- range $reserved -}}
            {{- $_ := unset $conf . -}}
          {{- end -}}
          {{/* Assign Values */}}
          {{- if ($conf.values) -}}
            {{- $values :=  $conf.values -}}
            {{- if not (kindIs "map" $values) -}}
            {{- end -}}
            {{- $_ := set $component "values" $values -}}
          {{- end -}}
          {{/* Overwrite Component */}}
          {{- $component = mergeOverwrite $component $conf -}}
        {{- end -}}
      {{- end -}}
      {{/* Append to Components Train */}}
      {{- $component_train = append $component_train $component -}}
    {{- end -}}
    {{- range $cpt := $component_train -}}
      {{- $conditions := fromYaml (include "inventory.conditions.get" (dict "cpt" .name "groups" $.groups "ctx" $.ctx)) -}}
      {{- if (not (include "inventory.helpers.unmarshalingError" $conditions)) -}}
        {{- if (include "inventory.config.eval.debug" $.ctx) -}}
          {{- $_ := set $cpt "conditions" $conditions.conditions -}}
        {{- end -}}
        {{- if $conditions.errors -}}
          {{- $_ := set $cpt "errors" (append $cpt.errors $conditions.errors) -}}
        {{- end -}}
        {{ $paths := list }}
        {{- range $conditions.conditions -}}
          {{- if .paths -}}
            {{- $paths = concat $paths .paths -}}
          {{- end -}}
        {{- end -}}
        {{- if $paths -}}
          {{- $func_files := (dict "tpl" "inventory.components.pathFinder" "ctx" (dict "paths" $paths "ctx" $.ctx)) -}}
          {{- $files := (fromYaml (include $func_files.tpl $func_files.ctx)) -}}
          {{- if (not (include "inventory.helpers.unmarshalingError" $files)) -}}
            {{- if $files.files -}}
              {{- if (include "inventory.config.eval.debug" $.ctx) -}}
                {{- $_ := set $cpt "paths" $files.files -}}
              {{- end -}}
              {{/* Send Files to create the final train, the train includes the final merged files */}}
              {{- $train := fromYaml (include "inventory.components.train" (dict "cpt" . "files" $files.files "groups" $.groups "ctx" $.ctx)) -}}
              {{- if (not (include "inventory.helpers.unmarshalingError" $train)) -}}
                {{- if $train.errors -}}
                  {{ $_ := set $cpt "errors" (concat $cpt.errors $train.errors) -}}
                {{- end -}}
                {{/* Check if train contains files */}}
                {{- if $train.files -}}
                  {{- $_ := set . "files" $train.files -}}

                  {{/* Run PostRenderers */}}
                  {{- $func_post_render := (dict "tpl" "inventory.postrenders.execute" "ctx" (dict "cpt" $cpt "ctx" $.ctx)) -}}
                  {{- $post_render := (fromYaml (include "inventory.postrenders.execute" $func_post_render.ctx )) -}}
                  {{- if (not (include "inventory.helpers.unmarshalingError" $post_render)) -}}
                    {{- $cpt = $post_render.cpt -}}
                  {{- else -}}

                  {{- end -}}



                {{- end -}}



 

              {{- else -}}

              {{- end -}}
              
             {{- $_ := set . "files" $train.files -}}

              {{- $_ := set . "errors" $train.errors -}}


            {{- end -}}
          {{- else -}}
            {{- $err := fromYaml (include "inventory.helpers.errors.func" (dict "tpl" $func_files.tpl "func_ctx" $func_files.ctx "ctx" $.ctx)) -}}
            {{- $_ := set $cpt "errors" (append $cpt.errors (dict "test" $err)) -}}
          {{- end -}}
        {{- end -}}
      {{- else -}}
        {{- $_ := set $cpt "errors" (append $cpt.errors (dict "error" (printf "Template 'inventory.int.conditions.get' returned '%s'" $conditions.Error))) -}}
      {{- end -}}

      {{/* Redirect Component Errors */}}
      {{- if $cpt.errors -}}
        {{- range $cpt.errors -}}
          {{- $_ := set . "component" $cpt.name -}}
        {{- end -}}
        {{- $_ := set $return "errors" (concat $return.errors $cpt.errors) -}}
      {{- end -}}  

      {{/* Generate Train Metadata */}}
      {{- $_ := set $cpt "meta" (dict "amount" (keys $cpt.files | len)) -}}

      {{/* Redirect to Return */}}
      {{- $_ := set $return "components" (append $return.components $cpt) -}}
    {{- end -}}
    {{- printf "%s" (toYaml $return) -}}
  {{- end -}}
{{- end -}}