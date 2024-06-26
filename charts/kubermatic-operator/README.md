# kubermatic-operator

![Version: 1.1.2](https://img.shields.io/badge/Version-1.1.2-informational?style=flat-square) ![AppVersion: v2.25.5](https://img.shields.io/badge/AppVersion-v2.25.5-informational?style=flat-square)

Helm chart to install the Kubermatic Operator

**Homepage:** <https://www.kubermatic.com/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| oliverbaehler | <oliverbaehler@hotmail.com> |  |
| chifu1234 | <kk@sudo-i.net> |  |

## Source Code

* <https://github.com/kubermatic/kubermatic>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| kubermaticOperator.affinity | object | `{}` | Operator affinity |
| kubermaticOperator.args | object | `{}` | Arguments for Container |
| kubermaticOperator.command | list | `["kubermatic-operator"]` | Command execute for Container |
| kubermaticOperator.crds | object | `{"install":true,"keep":true}` | Manage CRD Lifecycle |
| kubermaticOperator.crds.install | bool | `true` | Install the CustomResourceDefinitions (This also manages the lifecycle of the CRDs for update operations) |
| kubermaticOperator.crds.keep | bool | `true` | Keep the CustomResourceDefinitions (when the chart is deleted) |
| kubermaticOperator.debug | bool | `false` | Additional arguments for the operator |
| kubermaticOperator.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| kubermaticOperator.image.registry | string | `"quay.io"` | Image Registry |
| kubermaticOperator.image.repository | string | `"kubermatic/kubermatic"` | Image Repository |
| kubermaticOperator.image.tag | string | `""` | Image Tag |
| kubermaticOperator.imagePullSecret | list | `[]` | ImagePullSecrets |
| kubermaticOperator.leaderElection | bool | `true` |  |
| kubermaticOperator.livenessProbe | object | `{"enabled":false,"httpGet":{"path":"/healthz","port":10080},"initialDelaySeconds":60}` | Configure the liveness probe using Deployment probe spec |
| kubermaticOperator.nodeSelector | object | `{}` | Operator nodeSelector |
| kubermaticOperator.podAnnotations | object | `{"fluentbit.io/parser":"json_iso","prometheus.io/port":"8085","prometheus.io/scrape":"true"}` | Additional Pod Annotations |
| kubermaticOperator.podLabels | object | `{}` | Additional Pod Labels |
| kubermaticOperator.podSecurityContext | object | `{"enabled":true,"seccompProfile":{"type":"RuntimeDefault"}}` | SecurityContext for Pod |
| kubermaticOperator.rbac.create | bool | `true` | Create RBAC for Controller |
| kubermaticOperator.readinessProbe | object | `{"enabled":false,"httpGet":{"path":"/readyz","port":10080},"initialDelaySeconds":60}` | Configure the readiness probe using Deployment probe spec |
| kubermaticOperator.replicaCount | int | `1` | Amount of replicas |
| kubermaticOperator.resources | object | `{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"50m","memory":"128Mi"}}` | Resources for the Operator |
| kubermaticOperator.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"enabled":true,"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":65534}` | SecurityContext for Container |
| kubermaticOperator.serviceAccount.annotations | object | `{}` |  |
| kubermaticOperator.serviceAccount.create | bool | `true` |  |
| kubermaticOperator.serviceAccount.name | string | `""` |  |
| kubermaticOperator.serviceMonitor.annotations | object | `{}` | Assign additional Annotations |
| kubermaticOperator.serviceMonitor.enabled | bool | `false` | Enable ServiceMonitor |
| kubermaticOperator.serviceMonitor.endpoint.interval | string | `"15s"` | Set the scrape interval for the endpoint of the serviceMonitor |
| kubermaticOperator.serviceMonitor.endpoint.metricRelabelings | list | `[]` | Set metricRelabelings for the endpoint of the serviceMonitor |
| kubermaticOperator.serviceMonitor.endpoint.relabelings | list | `[]` | Set relabelings for the endpoint of the serviceMonitor |
| kubermaticOperator.serviceMonitor.endpoint.scrapeTimeout | string | `""` | Set the scrape timeout for the endpoint of the serviceMonitor |
| kubermaticOperator.serviceMonitor.jobLabel | string | `"app.kubernetes.io/name"` | Set JobLabel for the serviceMonitor |
| kubermaticOperator.serviceMonitor.labels | object | `{}` | Assign additional labels according to Prometheus' serviceMonitorSelector matching labels |
| kubermaticOperator.serviceMonitor.matchLabels | object | `{}` | Change matching labels |
| kubermaticOperator.serviceMonitor.namespace | string | `""` | Install the ServiceMonitor into a different Namespace, as the monitoring stack one (default: the release one) |
| kubermaticOperator.serviceMonitor.targetLabels | list | `[]` | Set targetLabels for the serviceMonitor |
| kubermaticOperator.tolerations | list | `[]` | Operator tolerations |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
