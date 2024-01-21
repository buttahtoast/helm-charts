# acceleration

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.2.13](https://img.shields.io/badge/AppVersion-0.2.13-informational?style=flat-square)

Harbor Acceleration Service

**Homepage:** <https://github.com/goharbor/acceleration-service>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| oliverbaehler | <oliverbaehler@hotmail.com> |  |
| chifu1234 | <kk@sudo-i.net> |  |

## Source Code

* <https://goharbor.io>
* <https://github.com/goharbor/harbor>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://buttahtoast.github.io/helm-charts/ | library | 3.0.0-rc.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| config.converter | object | `{"driver":{"config":{"with_referrer":true},"type":"nydus"},"harbor_annotation":true,"platforms":"","rules":{"additional":[],"overwrite":[]},"worker":5}` | Converter Configuration |
| config.converter.driver.config | object | `{"with_referrer":true}` | driver configuration |
| config.converter.driver.type | string | `"nydus"` | select which driver to use, `nydus` or `estargz` |
| config.converter.harbor_annotation | bool | `true` | enable to add harbor specified annotations to converted image for tracking. |
| config.converter.platforms | string | `""` | only convert images for specific platforms, leave empty for all platforms (eg. `linux/amd64,linux/arm64`) |
| config.converter.rules | object | `{"additional":[],"overwrite":[]}` | Additional rules |
| config.converter.rules.additional | list | `[]` | Additional rules (appened to driver preset rules) |
| config.converter.rules.overwrite | list | `[]` | Overwrite rules (overwrite driver preset rules) |
| config.converter.worker | int | `5` | number of worker for executing conversion task |
| config.customConfiguration | object | `{}` | Custom Configuration (instead of using template). Can be map or multiline string, templating is supported. |
| config.harbor.auth | string | `""` | Authentication Token |
| config.harbor.host | string | `"harbor.company.com"` |  |
| config.harbor.insecure | bool | `false` | skip verifying server certs for HTTPS source registry |
| config.template | string | `"# Configuration file of Harbor Acceleration Service\n\n# http related config\nserver:\n  name: API\n  # listened host for http\n  host: 0.0.0.0\n  # port for http\n  port: 2077\n\nmetric:\n  # export metrics on `/metrics` endpoint\n  enabled: true\n\nprovider:\n  source:\n    # hostname of harbor service\n    {{ $.Values.config.harbor.host }}:\n      # base64 encoded `<robot-name>:<robot-secret>` for robot\n      # account created in harbor\n      # auth: YTpiCg==\n      # skip verifying server certs for HTTPS source registry\n      insecure: {{ $.Values.config.harbor.insecure }}\n      webhook:\n        # webhook request auth header configured in harbor\n        auth_header: header\n    localhost:\n      # If auth is not provided, it will attempt to read from docker config\n      # auth: YWRtaW46SGFyYm9yMTIzNDU=\n  # work directory of acceld\n  work_dir: {{ $.Values.config.workDir.path }}\n  gcpolicy:\n      # size threshold that triggers GC, the oldest used blobs will be reclaimed if exceeds the size.\n      threshold: 1000MB\n  # remote cache record capacity of converted layers, default is 200.\n  cache_size: 200\n  # remote cache version, cache in remote must match the specified version, or discard cache.\n  cache_version: v1 \n\nconverter:\n  worker: {{ $.Values.config.converter.worker }}\n  harbor_annotation: {{ $.Values.config.converter.harbor_annotation }}\n  platforms: {{ $.Values.config.converter.platforms }}\n  rules:\n  {{- if $.Values.config.converter.overwrite }}\n    {{- toYaml $.Values.config.converter.overwrite | nindent 8 }}\n  {{- else }}\n    {{- if (include \"acceleration.driver.is.nydus\" $) }}\n    # add suffix to tag of source image reference as target image reference\n    - tag_suffix: -nydus\n    # set tag of source image reference as remote cache reference, leave empty to disable remote cache.\n    - cache_tag: nydus-cache\n    {{- end }}\n    {{- if (include \"acceleration.driver.is.estargz\" $) }}\n     - tag_suffix: -esgz\n    {{- end }}\n    {{- with $.Values.config.converter.rules.additional }}\n      {{- toYaml . | nindent 8 }}\n    {{- end }}\n  {{- end }}\n\n  driver:\n    # accelerator driver type: `nydus`\n    {{- if (include \"acceleration.driver.is.nydus\" $) }}\n    type: nydus\n    {{- end }}\n    {{- if (include \"acceleration.driver.is.estargz\" $) }}\n    type: estargz\n    {{- end }}\n    config:\n      work_dir: {{ $.Values.config.workDir.path }}\n      {{- if (include \"acceleration.driver.is.estargz\" $) }}\n      docker2oci: true\n      {{- end }}\n      {{- if (include \"acceleration.driver.is.nydus\" $) }}\n      with_referrer: true\n      {{- end }}\n      {{- with $.Values.config.converter.driver.config }}\n        {{- toYaml . | nindent 6 }}\n      {{- end }}\n"` | Configuration Template |
| config.workDir | object | `{"emptyDir":{"enabled":true,"medium":"","sizeLimit":""},"path":"/tmp"}` | Working Directory (EmptyDir) |
| config.workDir.emptyDir.enabled | bool | `true` | Enable EmptyDir for working directory |
| config.workDir.emptyDir.medium | string | `""` | EmptyDir medium |
| config.workDir.emptyDir.sizeLimit | string | `""` | EmptyDir size limit |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"goharbor/harbor-acceld"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.ingressClassName | string | `""` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.annotations | object | `{}` |  |
| service.clusterIP | string | `""` |  |
| service.labels | object | `{}` |  |
| service.loadBalancerIP | string | `""` |  |
| service.loadBalancerSourceRanges | list | `[]` |  |
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| serviceMonitor.annotations | object | `{}` | Assign additional Annotations |
| serviceMonitor.enabled | bool | `false` | Enable ServiceMonitor |
| serviceMonitor.endpoint.interval | string | `"15s"` | Set the scrape interval for the endpoint of the serviceMonitor |
| serviceMonitor.endpoint.metricRelabelings | list | `[]` | Set metricRelabelings for the endpoint of the serviceMonitor |
| serviceMonitor.endpoint.relabelings | list | `[]` | Set relabelings for the endpoint of the serviceMonitor |
| serviceMonitor.endpoint.scrapeTimeout | string | `""` | Set the scrape timeout for the endpoint of the serviceMonitor |
| serviceMonitor.jobLabel | string | `"app.kubernetes.io/name"` | Set JobLabel for the serviceMonitor |
| serviceMonitor.labels | object | `{}` | Assign additional labels according to Prometheus' serviceMonitorSelector matching labels |
| serviceMonitor.matchLabels | object | `{}` | Change matching labels |
| serviceMonitor.namespace | string | `""` | Install the ServiceMonitor into a different Namespace, as the monitoring stack one (default: the release one) |
| serviceMonitor.targetLabels | list | `[]` | Set targetLabels for the serviceMonitor |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
