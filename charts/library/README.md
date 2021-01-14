# Buttahtoast Library

![Version: 0.3.3](https://img.shields.io/badge/Version-0.3.3-informational?style=flat-square) ![Type: library](https://img.shields.io/badge/Type-library-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

This is our take on a library Chart. It contains simple functions which are (will be) used across all of our charts. Feel free the add or improve the existing templates. This Chart is still under development/testing. Feel free to use it, if you find any issues with it, please create an issue/PR. We will try to get bugs fixed as soon as possible!

**Homepage:** <https://github.com/buttahtoast/helm-charts/tree/master/charts/library>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| oliverbaehler | oliverbaehler@hotmail.com |  |
| chifu1234 | kk@sudo-i.net |  |

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
| All **string**, **list**, **globals** and **dict** templates | `0.3.0` | Added for each template category the category as template name path. (eg. all string templates = `lib.utils.strings.*`).| [Pull Request](https://github.com/buttahtoast/helm-charts/pull/15) |

# Templates

The available template functions are grouped by Data Type or Usage. Each describing how the template is called, what
it should do and what it should return. **NOTICE** We had to use single `{` in the examples, because helm-docs tries to
parse the file and that causes some issues. So don't forget to add a pair of `{}`.

**Template Index**

* **[Common](#common)**
  * [Fullname](#fullname)
  * [SelectorLabels](#selectorlabels)
  * [DefaultLabels](#defaultlabels)
  * [OverwriteLabels](#overwritelabels)
  * [CommonLabels](#commonlabels)
  * [Labels](#labels)
  * [KubeCapabilities](#kubecapabilities)
* **[Globals](#globals)**
  * [DockerImage](#dockerimage)
  * [ImagePullPolicy](#imagepullpolicy)
  * [ImagePullsecrets](#imagepullsecrets)
  * [StorageClass](#storageclass)
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
* **[Extras](#extras)**
  * [Environment](#environment)
  * [ExtraResources](#extraresources)
* **[Experimental](./templates/utils/_experimental.tpl)**

## [Common](./templates/utils/_common.tpl)

Making use of all the common templates enable the following keys:

  * [All Common Values can be found here](./templates/values/_common.yaml)

### Fullname
---

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

### SelectorLabels
---

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

### DefaultLabels
---

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

### CommonLabels
---

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

### Labels
---

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

### KubeCapabilities
---

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

### DockerImage
---

This function overwrites local docker registries with global defined registries, if available. Returns the assembled output
based on registry, repository and tag. The `$.global.defaultTag` value has precedence over the `.default` value.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.image` - Local Registry definition, see the structure below (Required).
  * `.context` - Inherited Root Context (Required). Make sure global variables are accessible through the context.
  * `.default` - Add a default value for the tag, if not set explicit (Optional, Defaults to "latest")

#### Structure

The following structure is expected for the key '.registry'. Keys with a '*' are optional. If on a parent key, this means you can
add the structure with the parent key or just the structure within the parent key.

```
image*:
  registry: docker.io
  repository: bitnami/apache
  tag*: latest

or

registry: docker.io
repository: bitnami/apache
tag*: latest
```

#### Keys

This function enables the following keys on the global scope:

```
global:

  ## Global Docker Image Registry
  # global.imageRegistry -- Global Docker Image Registry declaration. Will overwrite all child .registry fields.
  imageRegistry: "company-registry/"

  ## Global Default Image Tag
  # global.defaultTag -- Global Docker Image Tag declaration. Will be used as default tag, if no tag is given by child
  defaultTag: "1.0.0"
```

Each image referenced automatically is expected to have the above structure in the values (Example):

```
apache:
  registry*: docker.io
  repository: bitnami/apache
  tag*: latest

or

apache:
  image:
    repository: bitnami/apache
```

Is included as:

```
      containers:
        - name: apache
          image: {- include "lib.utils.globals.image" (dict "image" .Values.apache "context" $ "default" .Chart.AppVersion) }
```

#### Returns

String

#### Usage

```
{- include "lib.utils.globals.image" (dict "registry" .Values.image "context" $ "default" .Chart.AppVersion) }
```

### ImagePullPolicy
---

This function overwrites local docker image pullpolicies with global defined pullpolicies, if available.

####  Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.imagePullPolicy` - Local docker image pullPolicy, which are overwritten if the global variable is set. If neither is set, an empty string is returned (Required).
  * `.context` - Inherited Root Context (Required). Make sure global variables are accessible through the context.

#### Structure

The following structure is expected for the key '.persistence'. Keys with a '*' are optional. If on a parent key, this means you an
add the structure with the parent key or just the structure within the parent key.

```
image*:
  imagePullPolicy: "Always"

or

imagePullPolicy: "Always"
```

Would both work with example:

```
{- include "lib.utils.globals.pullPolicy" (dict "imagePullPolicy" .Values "context" $) }
```
#### Keys

This function enables the following keys on the global scope:

```
global:

  ## Global Docker Image PullPolicy
  # global.imagePullPolicy -- Global Docker Image Pull Policy declaration. Will overwrite all child .pullPolicy fields.
  imagePullPolicy: "Always"
```

#### Returns

String

#### Usage

```
{- include "lib.utils.globals.imagePullPolicy" (dict "pullPolicy" .Values.image.pullpolicy "context" $) }
```

### ImagePullsecrets
---

This function merges local pullSecrets with global defined pullSecrets, if available.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.pullSecrets` - Local pullSecrets, which are overwritten if the global variable is set. If neither is set, an empty string is returned (Optional, Defaults to empty).
  * `.context` - Inherited Root Context (Required). Make sure global variables are accessible through the context.

#### Keys

This function enables the following keys:

```
global:

  ## Global Image Pull Secrets
  # global.imagePullSecrets -- Global Docker Image Pull Secrets declaration. Added to local Docker Image Pull Secrets.
  imagePullSecrets: []
```

#### Returns

YAML Structure, String

#### Usage

```
{- include "lib.utils.globals.imagePullSecrets" (dict "pullSecrets" .Values.imagePullSecrets "context" $) }
```

### StorageClass
---

This Function checks for a global storage class and returns it, if set.
With the Parameter "persistence" you can pass your persistence structure. The function
is looking for a storageClass definition. If the Kind of the "persistence" is string,
it's assumed the storageClass was directly given. If not, the function will look for a .storageClass
in the given structure.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.persistence` - Local StorageClass/Persistence configuration, see the structure below.
  * `.context` - Inherited Root Context (Required). Make sure global variables are accessible through the context.

#### Structure

The following structure is expected for the key '.persistence'. Keys with a '*' are optional. If on a parent key, this means you can
add the structure with the parent key or just the structure within the parent key.

```
persistence*:
  storageClass: "local-storage"

or

persistence: "local-storage"
```

#### Keys

This function enables the following keys:

```
global:

  ## Global StorageClass
  # global.storageClass -- Global StorageClass declaration. Can be used to overwrite StorageClass fields.
  storageClass: ""
```

#### Returns

String

#### Usage

```
{ include "lib.utils.globals.storageClass" (dict "persistence" .Values.persistence "context" $) }
```

## [Strings](./templates/utils/_strings.tpl)

### Template
---

This function allows to render String/Map input with the go template engine. Since the
go template engine doesn't directly accept maps, maps are dumped in YAML format. If you want to
reuse the returned value, you need to use the fromYaml function. If you have a multiline YAML, but you want
to render it as part of the YAML Structure, use +|. This YAML multiline indicator will be replaced by \n.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.value` - Content you want to template. If a Go Struct, it will be dumped to YAML, since the tpl function only allows strings (Required).
  * `.extraValues` - Extra values you want to make available for the template function. Can be accessed through $.extraVars
  * `.context` - Inherited Root Context (Required).

#### Returns

YAML Structure, String

#### Usage

```
{ include "lib.utils.strings.template" (dict "value" .Values.path.to.the.Value "context" $ "extraValues" $extraValues) }

or

{ $structure := fromYaml (include "lib.utils.strings.template" (dict "value" .Values.path.to.the.Value "context" $)) }
```

### Stringify
---

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

### ToDns1123
---

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

### HasValueByKey
---

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
{- include "lib.utils.lists.getValueByKey" (dict "list" (list (dict "name" "firstItem" "value" "someValue") (dict "name" "secondItem" "value" "someValue2")) "value" "someValue2" "key" "value") -}
```

### GetValueByKey
---

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

### MergeListOnKey
---

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

### ExceptionList
---

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

### ParentAppend
---

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

### PrintYamlStructure
---

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

## [Extras](./templates/utils/_extras.tpl)

### Environment
---

Returns useful environment variables being used for container. In addition adds built-in proxy support to your chart.
Meaning proxy will be set directly in environment variables returned by the template.

#### Arguments

If an as required marked argument is missing, the template engine will fail intentionally.

  * `.` - Inherited Root Context (Required)

#### Structure

This template supports the following key structure:

  * [Proxy Values](./templates/values/extras/_proxy.yaml)

#### Returns

YAML Structure, String

Usage:

```
env: {- include "lib.utils.extras.environment" $ | nindent 2 }
```

### ExtraResources
---

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
