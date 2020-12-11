# Jira Software

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Unofficial Tavern Helm Chart

**Homepage:** <https://tavern.readthedocs.io/en/latest/>

# Major Changes

Major Changes to functions are documented with the version affected. **Before upgrading the dependency version, check this section out!**

| **Manifest** | **Chart Version** | **Change/Description** | **Commits/PRs** |
| :----------- | :---------------- | :--------------------- | :-------------- |
|||||

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| oliverbaehler | oliverbaehler@hotmail.com |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../library | library | >=0.0.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Pod [Affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) |
| annotations | object | `{}` |  |
| apiVersion | string | `""` | Declare API version for Cronjob/Job resource |
| args | object | `{}` | Configure arguments for executed command |
| command | object | `{}` | Configure executed container command |
| containerFields | object | `{}` | Container extra fields |
| cronjob.conf | object | `{"failedJobsHistoryLimit":10}` | Additional Configurations for CronJob resource |
| cronjob.enabled | bool | `false` | Deploy tavern as kind CronJob instead of kind Job (Reoccuring execution) |
| cronjob.schedule | string | `"0 * * * *"` | Define the schedule for the cronjob to run |
| environment | object | `{}` | Configure Environment Variables (Refer to values.yaml) |
| extraResources | list | `[]` | Define additional kubernetes manifests |
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
| nodeSelector | object | `{}` | Pod [NodeSelector](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) |
| podAnnotations | object | `{}` | Pod [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) are only added for the pod |
| podFields | object | `{}` | Add extra field to the [Pod Template](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#podtemplate-v1-core) if not available as value. |
| podLabels | object | `{}` | Pod [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) are only added for the pod |
| podSecurityContext | object | `{}` | Pod [SecurityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) |
| ports | object | `{}` | Configure Container Ports |
| priorityClassName | string | `""` | Pod [priorityClassName](https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass) |
| resources | object | `{}` | Configure Container [Resource](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) |
| restartPolicy | string | `"OnFailure"` | Restart policy for all containers within the One of Always, OnFailure, Never. Default to Always. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy |
| securityContext | object | `{}` | Container [SecurityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) |
| sidecars | list | `[]` | Allows to add sidecars to your [maincar]](https://kubernetes.io/docs/concepts/workloads/pods/#using-pods) |
| stageTemplates | list | `[]` | Tavern Test Stage Templates (See the examples) |
| tavern.debug | bool | `false` | Enables logging on DEBUG level |
| tavern.test_directory | string | `"/tavern"` | Directory where all your tests are mounted |
| testTemplates | list | `[]` | Tavern Test Suite Templates (See the examples) |
| tests | list | `[{"name":"Template Suite","secret":true,"template":"http_stage","test":{"stages":[{"name":"test_name","stage":{"test":"me"}}]},"values":{"enable_products":true}},{"name":"Sample Suite","test":{"stages":[{"name":"Try to get user","stage":{"request":{"json":{"clusterName":"test"},"method":"GET","url":"{host}/users/joebloggs"},"response":{"status_code":[200,404]}}},{"name":"Some Stage","stage":{"request":{"verify":true}},"template":"http_basic","values":{"endpoint":"Products"}}]}}]` | Tavern Test Suites which will be executed |
| tolerations | object | `{}` | Pod [Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |
| volumeMounts | object | `{}` | Configure Container [volumeMounts](https://kubernetes.io/docs/tasks/configure-pod-container/configure-volume-storage/) |
| volumes | list | `[]` | Additional [Volumes](https://kubernetes.io/docs/concepts/storage/volumes/) |

# Implementing Tests

## Using Templates

## Examples

See the [Examples](./examples) to get a better idea, of how tests could look like.
