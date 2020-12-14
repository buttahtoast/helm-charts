# Tavern

![Version: 0.1.2](https://img.shields.io/badge/Version-0.1.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Unofficial Tavern Helm Chart

The chart is under active development and may contain bugs/unfinished documentation. Any testing/contributions are welcome! :)

**Homepage:** <https://tavern.readthedocs.io/en/latest/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| oliverbaehler | oliverbaehler@hotmail.com |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://buttahtoast.github.io/helm-charts/ | library | 0.2.0 |

# Major Changes

Major Changes to functions are documented with the version affected. **Before upgrading the dependency version, check this section out!**

| **Change** | **Chart Version** | **Description** | **Commits/PRs** |
| :--------- | :---------------- | :-------------- | :-------------- |
|||||

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Pod [Affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) |
| annotations | object | `{}` |  |
| apiVersion | string | `""` | Declare API version for Cronjob/Job resource |
| args | object | `{}` | Configure arguments for executed command |
| command | object | `{}` | Configure executed container command |
| commonLabels | object | `{}` | Common Labels are added to each kubernetes resource manifest. But will not be added to resources rendered by the common chart (eg. JMX Exporter) |
| containerFields | object | `{}` | Container extra fields |
| cronjob.conf | object | `{"failedJobsHistoryLimit":10}` | Additional Configurations for CronJob resource |
| cronjob.enabled | bool | `false` | Deploy tavern as kind CronJob instead of kind Job (Reoccuring execution) |
| cronjob.schedule | string | `"0 * * * *"` | Define the schedule for the cronjob to run |
| environment | object | `{}` | Configure Environment Variables (Refer to values.yaml) |
| extraResources | list | `[]` | Define additional kubernetes manifests |
| fullnameOverride | string | `""` | Overwrite `lib.internal.fullname` output |
| global.imagePullPolicy | string | `""` |  |
| global.imagePullSecrets | list | `[]` | Global Docker Image Pull Secrets declaration. Added to local Docker Image Pull Secrets. |
| global.imageRegistry | string | `""` | Global Docker Image Registry declaration. Will overwrite all child .registry fields. |
| image.pullPolicy | string | `nil` | Configure Docker Pull Policy. Will be overwritten if set by global variable. |
| image.registry | string | `"docker.io"` | Configure Docker Registry. Will be overwritten if set by global variable. |
| image.repository | string | `"buttahtoast/docker-tavern"` | Configure Docker Repository |
| image.tag | string | Tag defaults to `.Chart.Appversion`, if not set | Configure Docker Image tag |
| imagePullSecrets | list | `[]` | Define [ImagePullSecrets](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/). Will be overwritten if set by global variable. |
| initContainers | list | `[]` | Pod [initContainers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) |
| job.conf | object | `{"ttlSecondsAfterFinished":120}` | Additional Configurations for CronJob resource |
| labels | object | `{}` |  |
| nameOverride | string | `""` | Overwrite "lib.internal.name" output |
| nodeSelector | object | `{}` | Pod [NodeSelector](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) |
| overwriteLabels | object | `{}` | Overwrites default labels, but not resource specific labels and common labels |
| podAnnotations | object | `{}` | Pod [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) are only added for the pod |
| podFields | object | `{}` | Add extra field to the [Pod Template](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#podtemplate-v1-core) if not available as value. |
| podLabels | object | `{}` | Pod [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) are only added for the pod |
| podSecurityContext | object | `{"fsGroup":1500,"runAsGroup":1500,"runAsUser":1500}` | Pod [SecurityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) |
| ports | object | `{}` | Configure Container Ports |
| priorityClassName | string | `""` | Pod [priorityClassName](https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass) |
| resources | object | `{}` | Configure Container [Resource](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) |
| restartPolicy | string | `"OnFailure"` | Restart policy for all containers within the One of Always, OnFailure, Never. Default to Always. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy |
| securityContext | object | `{"allowPrivilegeEscalation":false}` | Container [SecurityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) |
| sidecars | list | `[]` | Allows to add sidecars to your [maincar]](https://kubernetes.io/docs/concepts/workloads/pods/#using-pods) |
| stageTemplates | list | `[]` | Tavern Test Stage Templates (See the examples) |
| tavern.debug | bool | `false` | Enables logging on DEBUG level |
| tavern.defaultMode | string | `"0550"` |  |
| tavern.test_directory | string | `"/tavern"` | Directory where all your tests are mounted |
| testTemplates | list | `[]` | Tavern Test Suite Templates (See the examples) |
| tests | list | `[]` | Tavern Test Suites which will be executed |
| tolerations | object | `{}` | Pod [Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |
| volumeMounts | object | `{}` | Configure Container [volumeMounts](https://kubernetes.io/docs/tasks/configure-pod-container/configure-volume-storage/) |
| volumes | list | `[]` | Additional [Volumes](https://kubernetes.io/docs/concepts/storage/volumes/) |

# Implementing Tests

Tavern tests are implemented under the key `$.Values.tests`. Each element of this key represents a dedicated tavern test suite (dedicated configmap etc.). This is mainly because a configmap can maximum be up to 1MiB of data, therefor it makes sense to split each test suite into dedicate configmaps. See the [values.yaml](./values.yaml) as well as the example to see how it works!.

## Using Templates

This chart provides the functionality to create templates, which can be rereferenced. The templates allow you to implement go sprig logic and therefor might dramatically improve your tavern test suites.

**NOTE**: While tavern statements use single `{ .. }` I had to replace the go sprig `\{\{ .. }}` as well with single `{ .. }` because of the documenting engine.

### Stage

Tavern Stage templates are defined under the `$.Values.stageTemplates` key. You can define as many templates as you want below this key, just use the following semantic:

```
stageTemplates:

  ## Tavern template Name (Required)
- name: "stagetplname"

  ## Local Variables
  values:
    constant_url: "https://google.com"

  ## Here goes your tavern stage template
  template: |
    request:
      url: '{ $.tavern.constant_url }/{ default "/user" $.tavern.endpoint | trimAll "/" }'
      method: GET
      auth:
        - "{tavern.env_vars.BASIC_AUTH_USER}"
        - "{tavern.env_vars.BASIC_AUTH_PASSWD}"
      headers:
        content-type: "application/json"
    response:
      status_code:
        - 200
        - 301

  ## Tavern template Name (Required)
- name: "stagetplname2"

  ## Here goes your tavern stage template
  template: |
...
```

#### Reference

Referencing in a tavern test suite (same goes for test suite templates):

```
tests:
- name: "Simple Suite"
  values:
    endpoint: "products"
  test:
    stages:

      # Single Tavern Stage for Suite (Will be last stage to be executed)
      - name: "Test Stage"
        template: "stagetplname"
        values:
          endpoint: "products"
        stage:
          response:
            status_code:
              - 404
```

### Test Suites

Tavern Test Suite templates are defined under the `$.Values.testTemplates` key. You can define as many templates as you want below this key, just use the following semantic:

```
testTemplates
- name: "testtplname"
  values:
    test_scoped_value: "here"
    enable_base: true
  template: |
   stages:
   {- if $.tavern.enable_base }
     - name: "Base Call"
       stage:
         request:
           url: '{tavern.env_vars.HOST}/home'
           method: GET
           json: &base_data
             country: { $.Values.common.country }
           headers:
             content-type: "application/json"
         response:
           verify_response_with:
             function: "testing_utils:message_says_hello"
    {- end }

    # Single Tavern Stage for Suite (Will be last stage to be executed)
     - name: "Test Stage"
       template: "stagetplname"
       values:
         endpoint: "products"
       stage:
         response:
           status_code:
             - 404
```

#### Reference

Referencing in a tavern test suite:

```
## Tavern Test Suites
tests:

  # Single Tavern Stage for Suite using Template
  - name: "Product Suite"
    template: "testtplname"
    values:
      get_products: [ "Shirt", "Shorts", "Socks" ]
    test:
      stages:

        # Overtwrites/Merges with "Base Call" stage from Suite Template
        # Merged Stages will be executed at the end of the suite eventhough
        # they are the first stage defined in the template
        - name: "Base Call"
          stage:
            request:
              method: POST
              json:
                extraData: "extraValue"

        # Single Tavern Stage for Suite (Will be last stage to be executed)
        - name: "Test Admin User"
          template: "http_get"
          values:
            endpoint: "user?name=admin"
          stage:
            response:
              status_code:
                - 200
                - 301

```

# Tavern Concepts

To get to know to how tavern works, I recommend checking up their documentation on key concepts:

  * [https://tavern.readthedocs.io/en/latest/basics.html#](https://tavern.readthedocs.io/en/latest/basics.html#)

This will get you an idea on how to work with tavern.

## Traps

There's some things to note about tavern:

  * The name of Tavern test files must follow this syntax: `test_<custom_name>.tavern.yaml`. Otherwise tavern won't run any tests from this file.

## Environment Variables

There are different ways to reference external values within a tavern test suite. To reference environment variables:

```
...
  json:
    user: "{tavern.env_vars.BASIC_AUTH_USER}"
...
```

`BASIC_AUTH_USER` represents a environment variable.

Further explanation: [https://tavern.readthedocs.io/en/latest/basics.html#environment-variables](https://tavern.readthedocs.io/en/latest/basics.html#environment-variables)

## External Scripts

Tavern Jobs support by default the inclusion of external scripts. The easiest way to add scripts to your tavern instance is by mounting it into the `/scripts` directory within the container. The directory is already part of the `PYTHONPATH` and have the correct permissions.

## Includes

Currently no `!include` statements are supported for external files. We recommend using Environment Variables instead.

```
includes:
- !include common.yaml
```

The !include statement is removed by the go sprig toYaml function. Therefor it's not suppported yet. If you have a solution to this, create an Issue/PR.

## Examples

See the [Examples](./examples) to get a better idea, of how tests could look like.
