# Tavern

![Version: 0.3.0](https://img.shields.io/badge/Version-0.3.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Unofficial Tavern Helm Chart

The chart is under active development and may contain bugs/unfinished documentation. Any testing/contributions are welcome! :)

**Homepage:** <https://tavern.readthedocs.io/en/latest/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| oliverbaehler | oliverbaehler@hotmail.com |  |
| chifu1234 | kk@sudo-i.net |  |

## Source Code

* <https://github.com/buttahtoast/helm-charts/tree/master/charts/tavern>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://bedag.github.io/helm-charts | manifests | >= 0.4.0 < 1.0.0 |

# Major Changes

Major Changes to functions are documented with the version affected. **Before upgrading the dependency version, check this section out!**

| **Change** | **Chart Version** | **Description** | **Commits/PRs** |
| :--------- | :---------------- | :-------------- | :-------------- |
|||||

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| commonLabels | object | `{}` | Common Labels are added to each kubernetes resource manifest. |
| extraResources | list | `[]` | Enter Extra Resources managed by the release |
| fullnameOverride | string | `""` | Overwrite `lib.utils.common.fullname` output |
| global.imagePullPolicy | string | `""` | Global Docker Image Pull Policy declaration. Will overwrite all child .pullPolicy fields. |
| global.imagePullSecrets | list | `[]` | Global Docker Image Pull Secrets declaration. Added to local Docker Image Pull Secrets. |
| global.imageRegistry | string | `""` | Global Docker Image Registry declaration. Will overwrite all child .registry fields. |
| job.activeDeadlineSeconds | int | `nil` | Specifies the duration in seconds relative to the startTime that the job may be active before the system tries to terminate it; value must be positive integer. |
| job.affinity | object | `{}` | Pod [Affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) |
| job.annotations | object | `{}` | Configure CronJob Annotations |
| job.apiVersion | string | `""` | Configure the api version used for the CronJob resource. |
| job.args | object | `{}` | Configure arguments for executed command |
| job.backoffLimit | int | 6 | Specifies the number of retries before marking this job failed. |
| job.command | object | `{}` | Configure executed container command |
| job.completions | int | `nil` | Specifies the desired number of successfully finished pods the job should be run with [More Info](https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/). |
| job.concurrencyPolicy | string | `nil` | Specifies how to treat concurrent executions of a Job. Valid values are: - "Allow" (default): allows CronJobs to run concurrently; - "Forbid": forbids concurrent runs, skipping next run if previous run hasn't finished yet; - "Replace": cancels currently running job and replaces it with a new one. |
| job.containerFields | object | `{}` | Extra fields used on the container definition |
| job.containerName | string | `.Chart.Name` | Configure Container Name |
| job.enabled | bool | `true` | Enable CronJob Resource |
| job.environment | object | `{}` | Configure Environment Variables (Refer to values.yaml) |
| job.extraFields | object | `{}` | Extra fields used on the Job resource |
| job.failedJobsHistoryLimit | int | `1` | The number of failed finished jobs to retain. This is a pointer to distinguish between explicit zero and not specified. |
| job.forceRedeploy | bool | `false` |  |
| job.image.pullPolicy | string | `nil` | Configure Docker Pull Policy. Will be overwritten if set by global variable. |
| job.image.registry | string | `"docker.io"` | Configure Docker Registry. Will be overwritten if set by global variable. |
| job.image.repository | string | `"buttahtoast/docker-tavern"` | Configure Docker Repository |
| job.image.tag | string | Tag defaults to `.Chart.Appversion`, if not set | Configure Docker Image tag |
| job.imagePullSecrets | list | `[]` | Define [ImagePullSecrets](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/). Will be overwritten if set by global variable. |
| job.initContainers | list | `[]` | Pod [initContainers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) |
| job.labels | object | `{}` | Configure CronJob additional Labels |
| job.lifecycle | object | `{}` | Container [Lifecycle](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/) |
| job.livenessProbe | object | `{}` | Container [LivenessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-a-liveness-command) |
| job.nodeSelector | object | `{}` | Pod [NodeSelector](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) |
| job.parallelism | int | `nil` | manualSelector controls generation of pod labels and pod selectors. Leave `manualSelector` unset unless you are certain what you are doing. |
| job.podAnnotations | object | `{}` | Pod [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) are only added for the pod |
| job.podFields | object | `{}` | Add extra field to the [Pod Template](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#podtemplate-v1-core) if not available as value. |
| job.podLabels | object | `{}` | Pod [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) are only added for the pod |
| job.podSecurityContext | object | `{"fsGroup":1500,"runAsGroup":1500,"runAsUser":1500}` | Pod [SecurityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) |
| job.ports | list | `[]` | Configure Container Ports |
| job.priorityClassName | string | `""` | Pod [priorityClassName](https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass) |
| job.readinessProbe | object | `{}` | Container [ReadinessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-readiness-probes) |
| job.resources | object | `{}` | Configure Container [Resource](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) |
| job.restartPolicy | string | `"OnFailure"` | Restart policy for all containers within the pod. One of Always, OnFailure, Never. Default to Always. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy |
| job.schedule | string | `"0 * * * *"` | The schedule in Cron format, see https://crontab.guru/. |
| job.securityContext | object | `{}` | Container [SecurityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) |
| job.selector | object | `{}` | A label query over pods that should match the pod count. Normally, the system sets this field for you. |
| job.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| job.serviceAccount.apiVersion | string | v1 | Configure the api version used |
| job.serviceAccount.automountServiceAccountToken | bool | `true` | (bool) AutomountServiceAccountToken indicates whether pods running as this service account should have an API token automatically mounted. |
| job.serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| job.serviceAccount.enabled | bool | `false` | Specifies whether a service account is enabled or not |
| job.serviceAccount.globalPullSecrets | bool | `false` | Evaluate global set pullsecrets and mount, if set |
| job.serviceAccount.imagePullSecrets | list | `[]` | ImagePullSecrets is a list of references to secrets in the same namespace to use for pulling any images in pods that reference this ServiceAccount. |
| job.serviceAccount.labels | object | `{}` | Merges given labels with common labels |
| job.serviceAccount.name | string | `bedag-lib.fullname` | If not set and create is true, a name is generated using the fullname template |
| job.serviceAccount.secrets | list | `[]` | Secrets is the list of secrets allowed to be used by pods running using this ServiceAccount |
| job.sidecars | list | `[]` | Allows to add sidecars to your [maincar]](https://kubernetes.io/docs/concepts/workloads/pods/#using-pods) |
| job.startingDeadlineSeconds | string | `nil` | Optional deadline in seconds for starting the job if it misses scheduled time for any reason. Missed jobs executions will be counted as failed ones. |
| job.startupProbe | object | `{}` | Container [StartupProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-startup-probes) |
| job.successfulJobsHistoryLimit | string | 3 | The number of successful finished jobs to retain. This is a pointer to distinguish between explicit zero and not specified. |
| job.suspend | string | false | The number of successful finished jobs to retain. This is a pointer to distinguish between explicit zero and not specified. |
| job.tolerations | object | `{}` | Pod [Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |
| job.ttlSecondsAfterFinished | string | `nil` | ttlSecondsAfterFinished limits the lifetime of a Job that has finished execution (either Complete or Failed). |
| job.volumeMounts | list | `[]` | Configure Container [volumeMounts](https://kubernetes.io/docs/tasks/configure-pod-container/configure-volume-storage/) |
| job.volumes | list | `[]` | Additional [Volumes](https://kubernetes.io/docs/concepts/storage/volumes/) |
| kubeCapabilities | string | `$.Capabilities.KubeVersion.GitVersion` | Overwrite the Kube GitVersion |
| nameOverride | string | `""` | Overwrite "lib.internal.common.name" output |
| overwriteLabels | object | `{}` | Overwrites default labels, but not resource specific labels and common labels |
| proxy.httpProxy.host | string | `""` | Configure HTTP Proxy Hostname/IP (without protocol://) |
| proxy.httpProxy.port | int | `nil` | Configure HTTP Proxy Port |
| proxy.httpProxy.protocol | string | http | Configure HTTP Proxy Protocol (http/https) |
| proxy.httpsProxy.host | string | `""` | Configure HTTPS Proxy Hostname/IP (without protocol://) |
| proxy.httpsProxy.port | int | `nil` | Configure HTTPS Proxy Port |
| proxy.httpsProxy.protocol | string | http | Configure HTTPS Proxy Protocol (http/https) |
| proxy.noProxy | list | `[]` | Configure No Proxy Hosts noProxy: [ "localhost", "127.0.0.1" ] |
| selectorLabels | object | `{}` | Define default [selectorLabels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) |
| stageTemplates | list | `[]` | Tavern Test Stage Templates (See the examples) |
| tavern.asCronjob | bool | `false` | Runs Tavern as Cronjob, instead of Job |
| tavern.debug | bool | `false` | Enables logging on DEBUG level |
| tavern.defaultMode | string | `"0550"` | Default File mode for Test Suite mounts |
| tavern.test_directory | string | `"/tavern"` | Directory where all your tests are mounted |
| testTemplates | list | `[]` | Tavern Test Suite Templates (See the examples) |
| tests | list | `[{"name":"vanilla_test","secret":true,"test":"test_name: Make sure cookie is required to log in\n\nincludes:\n  - !include common.yaml\n\nstages:\n  - name: Try to check user info without login information\n    request:\n      url: \"{host}/userinfo\"\n      method: GET\n    response:\n      status_code: 401\n      json:\n        error: \"no login information\"\n      headers:\n        content-type: application/json\n","vanilla":true}]` | Tavern Test Suites which will be executed |
| tests[0].name | string | `"vanilla_test"` | Test Suite Name |
| tests[0].secret | bool | `true` | Test Suite Secret |
| tests[0].test | string | see `values.yaml` | Tavern Test Definition |
| timezone | string | `"Europe/Zurich"` | Define Container Timezone (Sets TZ Environment) |

# Implementing Tests

Tavern tests are implemented under the key `$.Values.tests`. Each element of this key represents a dedicated tavern test suite (dedicated configmap etc.). This is mainly because a configmap can maximum be up to 1MiB of data, therefor it makes sense to split each test suite into dedicate configmaps. See the [values.yaml](./values.yaml) as well as the example to see how it works!.

## Using Templates

This chart provides the functionality to create templates, which can be re referenced. The templates allow you to implement go sprig logic and therefor might dramatically improve your tavern test suites.

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
