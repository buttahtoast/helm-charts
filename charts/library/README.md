# Buttahtoast Library


## Add Dependency












# Functions

The available template functions are grouped by Data Type or Usage.


## Common

Common functions




### Common Labels

This template allows to define common labels. Common labels are appended to the base labels (no merge). By Using this template
the key `.Values.commonLabels` is considered in your value structure. If the key has values and is type `map` the values are used
as common labels.

#### Arguments

  If an as required marked argument is missing, the template engine will intentionally.

  * `.labels` - Local labels which will be merged over all the other resulting labels.
  * `.context` - Inherited Root Context (Required). Make sure global variables are accessible through the context.

#### Returns

String/YAML Structure


#### Usage

```
{{- include "lib.utils.labels" (dict "labels" (dict "custom.label" "value" "custom.label/2" "value") "context" $) }}
```






### Common Labels

This template allows to define common labels. Common labels are appended to the base labels (no merge). By Using this template
the key `.Values.commonLabels` is considered in your value structure. If the key has values and is type `map` the values are used
as common labels.

#### Arguments

  If an as required marked argument is missing, the template engine will intentionally.

  * `.` - Inherited Root Context (Required). Make sure global variables are accessible through the context.

#### Returns

String/YAML Structure

#### Usage

```
{{- include "lib.utils.labels" (dict "labels" (dict "custom.label" "value" "custom.label/2" "value") "context" $) }}
```

### Labels

This template wraps around the Default, Overwrite and Common Labels. Therefor all the configurations possible
configurations for the mentioned templates are also enabled through this template. In addition there is the possibility
to add labels, which overwrite the result of the wrapper itself.  

#### Arguments

  If an as required marked argument is missing, the template engine will intentionally.

  * `.labels` - Local labels which will be merged over all the other resulting labels.
  * `.context` - Inherited Root Context (Required). Make sure global variables are accessible through the context.

#### Returns

String/YAML Structure


#### Usage

```
{{- include "lib.utils.labels" (dict "labels" (dict "custom.label" "value" "custom.label/2" "value") "context" $) }}
```








## Globals

## Strings

### Template

This function allows to render String/Map input with the go template engine. Since the
go template engine doesn't directly accept maps, maps are dumped in YAML format. If you want to
reuse the returned value, you need to use the fromYaml function. If you have a multiline YAML, but you want
to render it as part of the YAML Structure, use +|. This YAML multiline indicator will be replaced by \n.

#### Arguments

If an as required marked argument is missing, the template engine will intentionally.

  * `.value` - Content you want to template. If a Go Struct, it will be dumped to YAML, since the tpl function only allows strings (Required).
  * `.extraValues` - Extra values you want to make available for the template function. Can be accessed through $.extraVars
  * `.context` - Inherited Root Context (Required).

#### Returns

String/YAML Structure

#### Usage

```
{{ include "lib.utils.template" (dict "value" .Values.path.to.the.Value "context" $ "extraValues" $extraValues) }}

or

{{ $structure := fromYaml (include "lib.utils.template" (dict "value" .Values.path.to.the.Value "context" $)) }}
```


### Stringify

This function allows to pass a list and create a single string, with a specific delimiter

#### Arguments

If an as required marked argument is missing, the template engine will intentionally.

  * `.list` - Expects input of type slice. If not given as slice, nothing will be returned (Required).
  * `.context` - Inherited Root Context (Required).
  * `.delimiter` - Chose the delimiter between each list object (Optional, Defaults to " ").

#### Returns

String/YAML Structure

#### Usage

```
{{ include "lib.utils.stringify" ( dict "list" (default (list 1 2 3) .Values.someList) "delimiter" ", " "context" $) }}
```

### ToDns1123

Converts the given string into DNS1123 accepted format. The format has the following conditions:

  a DNS-1123 subdomain must consist of lower case alphanumeric characters, '-' or '.', and
  must start and end with an alphanumeric character (e.g. 'example.com', regex used for
  validation is '[a-z0-9]([-a-z0-9][a-z0-9])?(.[a-z0-9]([-a-z0-9][a-z0-9])?)*'). And should be maximum 63 characters long.

If the input is not of type string, it's returned as is.

#### Arguments

If an as required marked argument is missing, the template engine will intentionaly.

  * `.` - The input you want to process by this function

#### Returns

String (1:1 return if not given as string)

#### Usage

```
{{ include "lib.utils.Todns-1123" "my-string" }}
```

*/}}









## Lists

### HasValueByKey

Loops through subdicts in a given lists checking the given key for the given value. if matched, true is returned.

#### Arguments

If an as required marked argument is missing, the template engine will intentionally.

  * `.list` - Expects a list with dictionaries as elements (Required)
  * `.value` - The value you are looking for in the dicts (Required)
  * `.key` - Define which key to query for the given value (Defaults to '.name')

#### Returns

Boolean

#### Usage

```
{{- include "lib.utils.getValueByKey" (dict "list" (list (dict "name" "firstItem" "value" "someValue") (dict "name" "secondItem" "value" "someValue2")) "value" "someValue2" "key" "value") -}}
```


### GetValueByKey

Loops through subdicts in a given lists checking the given key for the given value. if matched, the value of the entire dict is returned.

#### Arguments

If an as required marked argument is missing, the template engine will intentionally.

  * `.list` - Expects a list with dictionaries as elements (Required)
  * `.value` - The value you are looking for in the dicts (Required)
  * `.key` - Define which key to query for the given value (Defaults to '.name')

#### Returns

String/YAML Structure

#### Usage

```
{{- include "lib.utils.getValueByKey" (dict "list" (list (dict "name" "firstItem" "value" "someValue") (dict "name" "secondItem" "value" "someValue2")) "value" "someValue2" "key" "value") -}}
```

### MergeList

Merge two lists into one and returns the merged result.

#### Arguments

If an as required marked argument is missing, the template engine will intentionally.

  * . - Expects a list with two elements (Required).

#### Returns

String/YAML Structure

#### Usage

```
{{- include "lib.utils.mergeList" (list $firstlist $secondlist) -}}
```

### MergeListOnKey

The default behavior for merging lists in array don't allow a combination of two elements of the different lists.
Either you append the lists or completely overwrite the previous list. With this function you can merge list elements
based on a single key value together. Meaning if you have an element with the same name in both lists, the are treated
as the same element and merged specifically together.

#### Arguments

If an as required marked argument is missing, the template engine will intentionally.

  * `.source` - Base list (Required). If undefined, template will return no value.
  * `.target` - List merged over source list (Required). If undefined, template will return no value.
  * `.key` - Based on which Key list elements are merged. If not set `name` is used as key.
  * `.parentKey` - When trying to load the merged list you might encounter this error `json: cannot unmarshal array
    into Go value of type map[string]interface {}`. To avoid this set a parent key, which will include the merged list.

#### Returns

  String/YAML Structure

#### Usage

```
{{- include "lib.utils.mergeListOnKey" (dict "source" $.Values.sourceList "target" $.Values.targetList "key" "id") -}}
```
