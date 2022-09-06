# Buttahtoast Library

![Version: 3.0.0-rc.3](https://img.shields.io/badge/Version-3.0.0--rc.3-informational?style=flat-square) ![Type: library](https://img.shields.io/badge/Type-library-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

This is our take on a library Chart. It contains simple functions which are (will be) used across all of our charts. Feel free the add or improve the existing templates. This Chart is still under development/testing. Feel free to use it, if you find any issues with it, please create an issue/PR. We will try to get bugs fixed as soon as possible!

**Homepage:** <https://github.com/buttahtoast/helm-charts/tree/master/charts/library>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| oliverbaehler | <oliverbaehler@hotmail.com> |  |
| chifu1234 | <kk@sudo-i.net> |  |

# Install Chart

Since this chart is of type [library](https://helm.sh/docs/topics/library_charts/) it can only be used as dependency for other charts. Just add it in your chart dependencies section:

```
dependencies:
  - name: library
    version: 1.0.0
    repository: https://buttahtoast.github.io/helm-charts/
```

If the chart is within this Github helm repository, you can reference it as local dependency

```
dependencies:
- name: library
  version: ">=1.0.0"
  repository: "file://../library"
```

# Major Changes

Major Changes to functions are documented with the version affected. **Before upgrading the dependency version, check this section out!**

| **Template** | **Chart Version** | **Change/Description** | **Commits/PRs** |
| :----------- | :---------------- | :--------------------- | :-------------- |
| `$.Values.kubecapabilities` | `1.0.0` | `$.Values.kubecapabilities` moved to `$.Values.global.kubecapabilities`. Without mapping these values the kubeCapabilities no longer works. | [Pull Request](https://github.com/buttahtoast/helm-charts/pull/22) |
| All **string**, **list**, **globals** and **dict** templates | `0.3.0` | Added for each template category the category as template name path. (eg. all string templates = `lib.utils.strings.*`).| [Pull Request](https://github.com/buttahtoast/helm-charts/pull/15) |

# Templates

The available template functions are grouped by Data Type or Usage. Each describing how the template is called, what
it should do and what it should return. **NOTICE** We had to use single `{` in the examples, because helm-docs tries to
parse the file and that causes some issues. So don't forget to add a pair of `{}`.

**Template Index**

* **[Common](#common)**
  * [Fullname](#fullname)
  * [Chart](#chart)
  * [SelectorLabels](#selectorlabels)
  * [DefaultLabels](#defaultlabels)
  * [CommonLabels](#commonlabels)
  * [Labels](#labels)
  * [KubeCapabilities](#kubecapabilities)
* **[Strings](#strings)**
  * [Template](#template)
  * [Stringify](#stringify)
  * [ToDns1123](#todns1123)
* **[Lists](#lists)**
  * [HasValueByKey](#hasvaluebykey)
  * [GetValueByKey](#getvaluebykey)
  * [MergeList](#mergelist)
  * [MergeListOnKey](#mergelistonkey)
  * [ExceptionList](#exceptionlist)
* **[Dictionaries](#dictionaries)**
  * [ParentAppend](#parentAppend)
  * [PrintYamlStructure](#printyamlstructure)
  * [Get](#get)
  * [Set](#set)
  * [Unset](#unset)
  * [Merge](#merge)
* **[Extras](#extras)**
  * [Environment](#environment)
  * [Java Proxy](#java-proxy)
  * [ExtraResources](#extraresources)
* **[Errors](#errors)**
  * [fail](#fail)
  * [unmarshalingError](#unmarshalingerror)
  * [params](#params)
* **[Types](#types)**
  * [validate](#validate)

## [Common](./templates/utils/_common.tpl)

Making use of all the common templates enable the following keys:

  * [All Common Values can be found here](./templates/values/_common.yaml)

---

### Fullname

Extended Function to return a fullname.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.`/`.context` - Inherited Root Context (Required). Make sure global variables are accessible through the context.
  * `.name` - Define a custom name, without prefix. The given value will appended to an evaluated prefix. Becomes suffix of the `$.Values.fullnameOverride` property, if set. Can also be set through `.context.name`.
  * `.fullname` - Define a custom fullname. The given value will be returned as name. Is overwritten by the `$.Values.fullnameOverride` property, if set. Can also be set through `.context.fullname`.
  * `.prefix` - Define a custom Prefix for the fullname. (Defaults to `$.Release.Name`)

#### Keys

This function enables the following keys on the values scope:

```
## Overwrite Name Template
# nameOverride -- Overwrite "lib.internal.common.name" output
nameOverride: ""

## Overwrite Fullname Template
# fullnameOverride -- Overwrite `lib.utils.common.fullname` output
fullnameOverride: ""

```

#### Returns

String

#### Usage

```
{- include "lib.utils.common.fullname" $) }
```

---

### Chart

Chart Name

#### Returns

String

#### Usage

```
{- include "lib.internal.common.chart" $) }
```

---

### SelectorLabels

This template will return the default selectorLabels (Useable for Match/Selector Labels). In addition there is the
option to overwrite these labels. If no selectorLabels are defined, the following labels are set:

```
app.kubernetes.io/name: { include "lib.utils.common.name" . }
app.kubernetes.io/instance: { .Release.Name }
```

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.` - Inherited Root Context (Required). Make sure global variables are accessible through the context.

#### Keys

This function enables the following keys on the values scope:

```
## Selector Labels
# selectorLabels -- Define default [selectorLabels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)
selectorLabels: {}
```

#### Returns

YAML Structure, String

#### Usage

```
{- include "lib.utils.common.selectorLabels" $) }
```

---

### DefaultLabels

This template represents the default templates. It includes the `SelectorLabel` template and sets the Application Version.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.` - Inherited Root Context (Required). Make sure global variables are accessible through the context.

#### Returns

YAML Structure, String

#### Usage

```
{- include "lib.utils.common.defaultLabels" $) }
```

---

### OverwriteLabels

This template allows to define overwritting labels. Overwrite labels overwrite the default labels (DefaultLabels Template). By Using this template
the key `.Values.overwriteLabels` is considered in your value structure. If the key has values and is type `map` the values are used
as common labels.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.` - Inherited Root Context (Required). Make sure global variables are accessible through the context.

#### Keys

This function enables the following keys on the values scope:

```
## Overwrite Labels
# overwriteLabels -- Overwrites default labels, but not resource specific labels and common labels
overwriteLabels: {}
```

#### Returns

YAML Structure, String

#### Usage

```
{- include "lib.utils.common.overwriteLabels" $) }
```

---

### CommonLabels

This template allows to define common labels. Common labels are appended to the base labels (no merge). By Using this template
the key `.Values.commonLabels` is considered in your value structure. If the key has values and is type `map` the values are used
as common labels.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.` - Inherited Root Context (Required). Make sure global variables are accessible through the context.

#### Keys

This function enables the following keys on the values scope:

```
## Common Labels
# commonLabels -- Common Labels are added to each kubernetes resource manifest. But will not be added to resources rendered by the common chart (eg. JMX Exporter)
commonLabels: {}

## Overwrite Labels
# overwriteLabels -- Overwrites default labels, but not resource specific labels and common labels
overwriteLabels: {}
```

#### Returns

YAML Structure, String

#### Usage

```
{- include "lib.utils.common.commonLabels" $) }
```

---

### Labels

This template wraps around all the other label templates. Therefor all their functionalities are available with this template. In addition it's possible to pass labels, which overwrite the result of all the label templates.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `./.context` - Inherited Root Context (Required).
  * `.labels` - Labels which overwrite the resulting labels of all the other label templates.
  * `.versionUnspecific` - Removes the version label. Useful when you don't want your resource to be changed on version update (Spec Change).

#### Keys

This function enables the following keys on the values scope:

```
## Common Labels
# commonLabels -- Common Labels are added to each kubernetes resource manifest. But will not be added to resources rendered by the common chart (eg. JMX Exporter)
commonLabels: {}

## Overwrite Labels
# overwriteLabels -- Overwrites default labels, but not resource specific labels and common labels
overwriteLabels: {}

```

#### Returns

YAML Structure, String

#### Usage

```
{- include "lib.utils.common.labels" (dict "labels" (dict "custom.label" "value" "custom.label/2" "value") "context" $) }
```

---

### KubeCapabilities

This template allows to define a custom KubeCapabilities Version (replaces `$.Capabilities.KubeVersion.GitVersion`). This might be useful when
trying to test the chart or having client versions that differ from the server version.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.` - Inherited Root Context (Required). Make sure global variables are accessible through the context.

#### Keys

This function enables the following keys on the values scope:

```
## Version Capabilities
# kubeCapabilities -- Overwrite the Kube GitVersion
# @default -- `$.Capabilities.KubeVersion.GitVersion`
kubeCapabilities: "1.19.0"
```

#### Returns

String

#### Usage

```
{- if semverCompare ">=1.19-0" (include "lib.utils.common.capabilities" $) }
apiVersion: networking.k8s.io/v1
{- else if semverCompare ">=1.14-0" (include "lib.utils.common.capabilities" $context) -}
apiVersion: networking.k8s.io/v1beta1
{- else -}
```

## [Globals](./templates/utils/_globals.tpl)

Making use of all the global functions enable the following [global keys](https://helm.sh/docs/chart_template_guide/subcharts_and_globals/).

  * [All Global Values can be found here](./templates/values/_globals.yaml)

## [Strings](./templates/utils/_strings.tpl)

---

### Template

This function allows to render String/Map input with the go template engine. Since the
go template engine doesn't directly accept maps, maps are dumped in YAML format. If you want to
reuse the returned value, you need to use the fromYaml function. If you have a multiline YAML, but you want
to render it as part of the YAML Structure, use +|. This YAML multiline indicator will be replaced by \n.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.value` - Content you want to template. If a Go Struct, it will be dumped to YAML, since the tpl function only allows strings (Required).
  * `.extraValues` - Extra values you want to make available for the template function. Can be accessed through $.extraVars (Optional)
  * `.extraValuesKey` - Key which is used to publish `.extraValues`. Extra Value can be accessed through  `$.(.extraValuesKey)` if set (Optional)
  * `.context` - Inherited Root Context (Required).

#### Returns

YAML Structure, String

#### Usage

```
{ include "lib.utils.strings.template" (dict "value" .Values.path.to.the.Value "context" $ "extraValues" $extraValues) }

or

{ $structure := fromYaml (include "lib.utils.strings.template" (dict "value" .Values.path.to.the.Value "context" $)) }
```

---

### Stringify

This function allows to pass a list and create a single string, with a specific delimiter

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.list` - Expects input of type slice. If not given as slice, nothing will be returned (Required).
  * `.context` - Inherited Root Context (Required).
  * `.delimiter` - Chose the delimiter between each list object (Optional, Defaults to " ").

#### Returns

String

#### Usage

```
{ include "lib.utils.strings.stringify" ( dict "list" (default (list 1 2 3) .Values.someList) "delimiter" ", " "context" $) }
```

---

### ToDns1123

Converts the given string into DNS1123 accepted format. The format has the following conditions:

  a DNS-1123 subdomain must consist of lower case alphanumeric characters, '-' or '.', and
  must start and end with an alphanumeric character (e.g. 'example.com', regex used for
  validation is '[a-z0-9]([-a-z0-9][a-z0-9])?(.[a-z0-9]([-a-z0-9][a-z0-9])?)*'). And should be maximum 63 characters long.

If the input is not of type string, it's returned as is.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.` - The input you want to process by this function

#### Returns

String (1:1 return if not given as string)

#### Usage

```
{ include "lib.utils.strings.toDns1123" "my-string" }
```

## [Lists](./templates/utils/_lists.tpl)

---

### HasValueByKey

Loops through subdicts in a given lists checking the given key for the given value. if matched, true is returned.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.list` - Expects a list with dictionaries as elements (Required)
  * `.value` - The value you are looking for in the dicts (Required)
  * `.key` - Define which key to query for the given value (Defaults to '.name')

#### Returns

Boolean

#### Usage

```
{- include "lib.utils.lists.hasValueByKey" (dict "list" (list (dict "name" "firstItem" "value" "someValue") (dict "name" "secondItem" "value" "someValue2")) "value" "someValue2" "key" "value") -}
```

---

### GetValueByKey

Loops through subdicts in a given lists checking the given key for the given value. if matched, the value of the entire dict is returned.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.list` - Expects a list with dictionaries as elements (Required)
  * `.value` - The value you are looking for in the dicts (Required)
  * `.key` - Define which key to query for the given value (Defaults to '.name')

#### Returns

YAML Structure, String

#### Usage

```
{- include "lib.utils.lists.getValueByKey" (dict "list" (list (dict "name" "firstItem" "value" "someValue") (dict "name" "secondItem" "value" "someValue2")) "value" "someValue2" "key" "value") -}
```

---

### MergeList

Merge two lists into one and returns the merged result.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * ` .` - Expects a list with two elements (Required).

#### Returns

YAML Structure, String

#### Usage

```
{- include "lib.utils.lists.mergeList" (list $firstlist $secondlist) -}
```

---

### MergeListOnKey

The default behavior for merging lists in array don't allow a combination of two elements of the different lists.
Either you append the lists or completely overwrite the previous list. With this function you can merge list elements
based on a single key value together. Meaning if you have an element with the same name in both lists, the are treated
as the same element and merged specifically together.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.source` - Base list (Required). If undefined, template will return no value.
  * `.target` - List merged over source list (Required). If undefined, template will return no value.
  * `.key` - Based on which Key list elements are merged. If not set `name` is used as key.
  * `.parentKey` - When trying to load the merged list you might encounter this error `json: cannot unmarshal array
    into Go value of type map[string]interface {}`. To avoid this set a parent key, which will include the merged list.

#### Returns

YAML Structure, String

#### Usage

```
{- include "lib.utils.lists.mergeListOnKey" (dict "source" $.Values.sourceList "target" $.Values.targetList "key" "id") -}
```

---

### ExceptionList

This function allows list blacklisting. This means, that you can give an list of exceptions ("blacklist") as argument. The template
iterates over a given list with dictionary elements and removes elements, which match one of the value in the exception list.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.exceptions` - A list or space delimited string values, which are exceptions (Optional, Returns input list without modification)
  * `.list` - Data of type slice (Optional, Returns Empty String).
  * `.key` - Key checked for exception values (Optional, Defaults to "name")

#### Returns

YAML Structure, String

#### Usage:

```
{ include "lib.utils.lists.exceptionList" (dict "list" .Values.mylist "exceptions" (list "BLACKLISTED_VAR" "SHARED_HOME" "CLUSTERED" "DATADIR") "key" "special_key") }

or

{ include "lib.utils.lists.exceptionList" (dict "list" .Values.mylist "exceptions" "BLACKLISTED_VAR SHARED_HOME DATADIR" "key" "special_key") }
```

#### Example

Given this Input (Container Environment Variables):

```
environment:
  - name: "HOME"
    value: "/home/directory"
  - name: "IMPORTANT_CONFIGURATION"
    value: "important value"
  - name: "PRESET_CONFIGURATION"
    value: "generated"
  - name: "PRESET_HOSTNAME"
    value: "generated"
```

Calling Exception list:

```
{ include "lib.utils.lists.exceptionList" (dict "list" $.Values.environment "exceptions" "PRESET_HOSTNAME PRESET_CONFIGURATION") }

or

{ include "lib.utils.lists.exceptionList" (dict "list" $.Values.environment "exceptions" (list "PRESET_HOSTNAME" "PRESET_CONFIGURATION")) }

```

Results in:

```
- name: HOME
  value: /home/directory
- name: IMPORTANT_CONFIGURATION
  value: important value
```

## [Dictionaries](./templates/utils/_dicts.tpl)

---

### ParentAppend

This function allows to append a given interface-map to a new parent key and returns the resulting YAML structure.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.key` - The new parent key for the given key structure (Optional, Defaults to `Values` key)
  * `.append` - Key structure you want to append (Optional, Defaults to function Root Context)

#### Returns

YAML Structure, String

#### Usage:

```
{- include "lib.utils.dicts.parentAppend" (dict "key" "parent" "append" $.Values) }

or

{- include "lib.utils.dicts.parentAppend"  $.Values }
```

---

### PrintYamlStructure

This function allows to append a given struct to a new parent key and returns the resulting YAML structure.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.structure` - Enter the structure seperated by '.' (Required)
      E.g. the input of "Values.sub.key" will result in the output of:
        Values:
          sub:
            key:

  * `.data` - Data which will be inserted below the structure (Optional)

#### Returns

  String

#### Usage:

```
{- include "lib.utils.dicts.printYAMLStructure" (dict "structure" $path "data" "my.structure.here") }
```

Will result in

```
my:
  structure:
    here:
      {.data}
```

---

### Get

Get a specific key by delivering the key path from a given dictionary.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.path` - The key path
  * `.required` - If set to true, and the key path value is not found or empty, the template will fail (Optional)
  * `.data` - The dictionary to lookup

#### Returns

  Dictionary (With key `.res` in case the key resolves to a list)

#### Usage:

```
{- include "lib.utils.dicts.get" (dict "path" "sub.key" "data" (dict "sub" (dict "key" (list "A" "B" "C")))) }
```

Will result in

```
res:
  - A
  - B
  - C
```

You can directly resolve without the `res` field using the following:

```
{- (fromYaml (include "lib.utils.dicts.lookup" (dict "path" "sub.key" "data" (dict "sub" (dict "key" (list "A" "B" "C")))))).res }
```

---

### Unset

Unset a key by path in a dictionary

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.path` - The key path
  * `.data` - The dictionary to lookup

#### Returns

Directly removes key on dictionary, no return

#### Usage:

```
{- include "lib.utils.dicts.unset" (dict "path" "sub.key" "data" (dict "sub" (dict "key" (list "A" "B" "C")))) }
```

---

### Set

Set a key and it's value by path in a dictionary. The entire path is created, meaning subpaths don't have to exist to assign a value.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.path` - The key path
  * `.value` - The value to set
  * `.data` - The dictionary to lookup

#### Returns

Directly removes key on dictionary, no return

#### Usage:

```
{- include "lib.utils.dicts.set" (dict "path" "new.sub.key" "value" (dict "something" "new") "data" (dict "sub" (dict "key" (list "A" "B" "C")))) }
```

Will result in:

```
new:
  sub:
    key:
      something: new
sub:
  key:
    - A
    - B
    - C
```

### Merge

Nested dictionary merge (Including lists). The Result is redirected the `$.base` argument, th

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.base` - Base data
  * `.data` - Data which is merged over the Base data

#### List Options

**Inject Key**

With the Inject Key you can inject the list elements from the base list, which weren't preserved. By default only the elements of the data list are used (presceding).

```
# Base Data Dict
Base:
  spec:
    selector:
      app: nginx
    ports:
    - port: 80
      name: http
      targetPort: 80
    - port: 443
      name: https
      targetPort: 80

# Base Data Dict
Data:
  spec:
    ports:
    - __inject__

    # Overwrites HTTPS Port
    - port: 8443
      name: https

    # Add additional Port
    - port: 9001
      name: metrics
      targetPort: 9001
```

**Merge Key**

By default list elements are merged on the key **name**. You can change the key the lists are merged on. In this example the objects are merged, based on the value in the **port** field:

```
# Base Data Dict
Base:
  spec:
    selector:
      app: nginx
    ports:
    - port: 80
      name: http
      targetPort: 80
    - port: 443
      name: https
      targetPort: 80

# Base Data Dict
Data:
  spec:
    ports:
    - __inject__

    - ((port))

    # Overwrites HTTPS Port
    - port: 8443
      name: https

    # Add additional Port
    - port: 9001
      name: metrics
      targetPort: 9001
```

#### Returns

Direct operation on `$.Base`

#### Usage:

```
{- include "lib.utils.dicts.merge" (dict "base" $.Base "data" $.Data) }
```

## [Extras](./templates/utils/_extras.tpl)

---

### Environment

Returns useful environment variables being used for container. In addition adds built-in proxy support to your chart.
Meaning proxy will be set directly in environment variables returned by the template.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.` - Inherited Root Context (Required)

#### Structure

This template supports the following key structure:

  * [Proxy Values](./templates/values/_globals.yaml)

#### Returns

YAML Structure, String

Usage:

```
env: {- include "lib.utils.extras.environment" $ | nindent 2 }
```

---

### Java Proxy

Renders the JVM args for proxy configuration based on global values.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.` - Inherited Root Context (Required)

#### Structure

This template supports the following key structure:

  * [Proxy Values](./templates/values/_globals.yaml)

#### Returns

String

Usage:

```
env:
  - name: "JVM_ARGS"
    values: {- template "lib.utils.extras.java_proxy" $ }
```

---

### ExtraResources

Allows to have extra resources in the chart. Returns kind List with all given kubernetes extra resources.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.` - Inherited Root Context (Required)

#### Keys

This function enables the following keys:

```
## Raw Kubernetes resources
# extraResources --
extraResources: []
#
# - kind: ConfigMap
#   apiVersion: v1
#   metadata:
#     name: example-configmap
#   data:
#     database: mongodb
#     database_uri: mongodb://localhost:27017
#
```

#### Returns

YAML Structure, String

Usage:

```
env: {- include "lib.utils.extras.resources" $ | nindent 2 }
```

## [Errors](./templates/utils/_errors.tpl)

---

### Fail

Executes a fail but adds two new lines to make the error more visible.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.` -  Error Message

#### Returns

Helm Fail

#### Usage:

```
{- include "lib.utils.errors.fail" (printf "My Custom Error") }
```

### unmarshalingError
---

Evaluates a dictionary which was parsed from YAMl if it has an Error field.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally. Returns True if that's the case.

  * `.` -  Data

#### Returns

Bool

#### Usage:

```
{- if not (include "lib.utils.errors.unmarshalingError" (fromYaml (include "my.data" $))) }
No Error!
{- else -}
Error: (fromYaml (include "my.data" $)).Error
{- end -}
```

---

### Params

Prints an error that a template is missing parameters

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally. Returns True if that's the case.

  * `.tpl` -  Template Name
  * `.params` -  Parameter List

#### Returns

Helm Fail

#### Usage:

```
{- if and $.data $.ctx}
Do Stuff
{- else -}
  {- include "lib.utils.errors.params" (dict "tpl" "my.tpl" "params" (list "data" "ctx") }
{- end -}
```

# [Types](./templates/utils/_types.tpl)

---

### Validate

Validate Types against data. It's a simple abstraction of json schema for go sprig.

#### Type

This is what a type declartion could look like:

```
{- define "my.type" -}

# Field Config, matches the field name 'field-2'. The following properties are supported:22
field-2:

  # Declared 'field-2' as Required
  required: true

  # Allowed types for the content of 'field-2'
  types: [ "string", "slice" ]

  # Default Value if the field does not have a value
  default: "default-value"

  # Allowed Values for the fields value
  values: [ "dev", "prod" ]

# Field with just type
field-3:
  types: [ "map" ]

# Field with just default
field-3:
  default: "east"

# For nested dictionaries you need to use the _props keyword. If a field has the _props keyword
# as key, everything below that field is treated as nested recursion
field-4:
  _props:
    field-4-sub-1:
      types: [ "string" ]
      required: true
    field-4-sub-2:
      _props:
        field-4-sub-2-sub-1:
          types: [ "boolean" ]
{- end -}
```

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally. Returns True if that's the case.

  * `.type` -  Template Name of Type
  * `.data` - Check Type against the given data
  * `.validate` - Only validate, don't assign default values
  * `.properties` - Directly assign type properties instead of using a template
  * `.ctx` -  Global Context

#### Returns

  * `.isType` -  If given data is type
  * `.errors` -  Errors

#### Usage:

```
{- $validate := fromYaml (include "lib.utils.types.validate" (dict "type" "my.type" "data" some.data "ctx" $)) -}
{- if $validate.isType -}
  Valid
{- end -}
```