# Ant Media Server (AMS)

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.16.0](https://img.shields.io/badge/AppVersion-1.16.0-informational?style=flat-square)

**Homepage:** <https://antmedia.io/docs/guides/clustering-and-scaling/kubernetes/prepare-environment-to-deploy-ams-at-kubernetes/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| oliverbaehler | <oliverbaehler@hotmail.com> |  |
| chifu1234 | <kk@sudo-i.net> |  |

# Major Changes

Major Changes to functions are documented with the version affected. **Before upgrading the dependency version, check this section out!**

| **Template** | **Chart Version** | **Change/Description** | **Commits/PRs** |
| :----------- | :---------------- | :--------------------- | :-------------- |
|||||

# Backup & Restore

You can toggle a periodoic backup of the redis database with the `backup.enabled` parameter. [See Backup](#backup) for more information. The idea is to dump the snapshots to a pvc (which is backuped by the plattform) and have access to different states of the cluster.

When it comes to the case you need to perform a restore, we have the pod yaml prepared which lets you interact with the cluster and with the backups. Execute:

```shell
kubectl get configmap { $.Release.Name }-redis-backup -o jsonpath='{.data.restore\.yaml}'
```

Execute the restore helper:

```shell
kubectl exec -it { $.Release.Name }-restore -- bash
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| config.java | string | `"-Xms1g"` | JVM Memory Options(-Xms1g -Xmx4g): Set the Java heap size. |
| config.license | string | `""` | License Key |
| config.limits.cpu | int | `75` | Set the CPU limit percentage that server does not exceed. If CPU is more than this value, server reports highResourceUsage and does not allow publish or play. |
| config.limits.memory | int | `75` | Set the Memory Limit percentage that server does not exceed. If Memory usage is more than this value, server reports highResourceUsage and does not allow publish or play |
| config.mode | string | `"standalone"` | Server mode. It can be standalone or cluster. If cluster mode is specified then mongodb host, username and password should also be provided. |
| config.redis.config | string | `nil` | Custom Redison Configuration |
| config.redis.database | int | `0` | Redis Database-Key |
| coturn.affinity | object | `{}` | Set affinity rules |
| coturn.autoscaling.enabled | bool | `false` |  |
| coturn.autoscaling.maxReplicas | int | `100` |  |
| coturn.autoscaling.minReplicas | int | `1` |  |
| coturn.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| coturn.cmd | string | `nil` | Executed command |
| coturn.dnsPolicy | string | `"ClusterFirstWithHostNet"` | Set DNS Policy |
| coturn.enabled | bool | `false` | Enable CoTurn Server |
| coturn.envs | object | `{}` | Extra environment variables (`key: value` style, allows templating) |
| coturn.image.pullPolicy | string | `"Always"` | Image pull policy |
| coturn.image.registry | string | `"docker.io"` | Image Registry |
| coturn.image.repository | string | `"coturn/coturn"` | Image Repository |
| coturn.image.tag | string | `""` | Image Tag |
| coturn.ingress.annotations."cert-manager.io/cluster-issuer" | string | `"cloudflare"` |  |
| coturn.ingress.annotations."ingress.cilium.io/loadbalancer-mode" | string | `"shared"` |  |
| coturn.ingress.className | string | `"cilium"` |  |
| coturn.ingress.enabled | bool | `true` |  |
| coturn.ingress.host | string | `"origin.ant.buttah.cloud"` |  |
| coturn.ingress.path | string | `"/"` |  |
| coturn.ingress.pathType | string | `"Prefix"` |  |
| coturn.ingress.tls | bool | `true` |  |
| coturn.livenessProbe | object | `{"enabled":false,"httpGet":{"path":"/","port":5080},"initialDelaySeconds":30,"periodSeconds":10}` | Liveness Probe |
| coturn.nodeSelector | object | `{}` | Set the node selector |
| coturn.pdb.enabled | bool | `false` |  |
| coturn.pdb.maxUnavailable | int | `0` |  |
| coturn.pdb.minAvailable | int | `1` |  |
| coturn.podAnnotations | object | `{}` | Additional Pod Annotations |
| coturn.podLabels | object | `{}` | Additional Pod Labels |
| coturn.podSecurityContext | object | `{"enabled":true,"seccompProfile":{"type":"RuntimeDefault"}}` | SecurityContext for Pod |
| coturn.priorityClassName | string | `""` | Set a pod priorityClassName |
| coturn.readinessProbe | object | `{"enabled":true,"httpGet":{"path":"/","port":5080},"initialDelaySeconds":30,"periodSeconds":10}` | Readiness Probe |
| coturn.replicaCount | int | `1` | Amount of replicas |
| coturn.resources | object | `{}` |  |
| coturn.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"enabled":true,"readOnlyRootFilesystem":false,"runAsNonRoot":true,"runAsUser":999}` | SecurityContext for Container |
| coturn.strategy | object | `{"rollingUpdate":{"maxUnavailable":1},"type":"RollingUpdate"}` | Deployment Strategy |
| coturn.tolerations | list | `[]` | Set list of tolerations |
| coturn.topologySpreadConstraints | list | `[]` | Set Topology Spread Constraints |
| coturn.volumeMounts | list | `[]` | Additional volumeMounts on the output Deployment definition. |
| coturn.volumes | list | `[]` | Additional volumes on the output Deployment definition. |
| exporter.configuration.config | string | `"---\nmetrics:\n- name: antmedia\n  type: object\n  help: AntMedia Server broadcast statistics\n  path: $[*]\n  labels:\n    streamId: $.streamId\n    name: $.name\n    status: $.status\n    type: $.type\n  values:\n    speed: $.speed\n    bitrate: $.bitrate\n    hlsViewerCount: $.hlsViewerCount\n    webRTCViewerCount: $.webRTCViewerCount\n    rtmpViewerCount: $.rtmpViewerCount\n    mp4Enabled: $.mp4Enabled\n    webMEnabled: $.webMEnabled\n"` |  |
| exporter.enabled | bool | `false` | Enable Prometheus Exporter |
| fullnameOverride | string | `""` |  |
| global | object | `{}` |  |
| image.pullPolicy | string | `"Always"` | Image pull policy |
| image.registry | string | `"docker.io"` | Image Registry |
| image.repository | string | `"anguda/ant-media"` | Image Repository |
| image.tag | string | `""` | Image Tag |
| imagePullSecrets | list | `[]` | Image PullSecrets |
| kafka | object | `{"architecture":"replicaset","auth":{"enabled":true},"enabled":false,"metrics":{"enabled":true},"tls":{"enabled":false}}` | Kafka Dependency (Untested) |
| nameOverride | string | `""` |  |
| netpol.enabled | bool | `false` |  |
| netpol.ingress.from[0].namespaceSelector | object | `{}` |  |
| origin.affinity | object | `{}` | Set affinity rules |
| origin.autoscaling.enabled | bool | `false` |  |
| origin.autoscaling.maxReplicas | int | `100` |  |
| origin.autoscaling.minReplicas | int | `1` |  |
| origin.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| origin.cmd | string | `nil` | Executed command |
| origin.dnsPolicy | string | `"ClusterFirstWithHostNet"` | Set DNS Policy |
| origin.envs | object | `{}` | Extra environment variables (`key: value` style, allows templating) |
| origin.ingress.annotations | object | `{}` |  |
| origin.ingress.className | string | `""` |  |
| origin.ingress.enabled | bool | `true` |  |
| origin.ingress.hosts[0] | string | `"streams.company.com"` |  |
| origin.ingress.path | string | `"/"` |  |
| origin.ingress.pathType | string | `"Prefix"` |  |
| origin.ingress.tls | bool | `true` |  |
| origin.livenessProbe | object | `{"enabled":false,"httpGet":{"path":"/","port":5080},"initialDelaySeconds":30,"periodSeconds":10}` | Liveness Probe |
| origin.nodeSelector | object | `{}` | Set the node selector |
| origin.pdb.enabled | bool | `false` |  |
| origin.pdb.maxUnavailable | int | `0` |  |
| origin.pdb.minAvailable | int | `1` |  |
| origin.podAnnotations | object | `{}` | Additional Pod Annotations |
| origin.podLabels | object | `{}` | Additional Pod Labels |
| origin.podSecurityContext | object | `{"enabled":true,"seccompProfile":{"type":"RuntimeDefault"}}` | SecurityContext for Pod |
| origin.priorityClassName | string | `""` | Set a pod priorityClassName |
| origin.readinessProbe | object | `{"enabled":true,"httpGet":{"path":"/","port":5080},"initialDelaySeconds":5,"periodSeconds":10}` | Readiness Probe |
| origin.replicaCount | int | `1` | Amount of replicas |
| origin.resources | object | `{}` |  |
| origin.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"enabled":true,"readOnlyRootFilesystem":false,"runAsNonRoot":true,"runAsUser":999}` | SecurityContext for Container |
| origin.strategy | object | `{"rollingUpdate":{"maxUnavailable":1},"type":"RollingUpdate"}` | Deployment Strategy |
| origin.tolerations | list | `[]` | Set list of tolerations |
| origin.topologySpreadConstraints | list | `[]` | Set Topology Spread Constraints |
| origin.volumeMounts | list | `[]` | Additional volumeMounts on the output Deployment definition. |
| origin.volumes | list | `[]` | Additional volumes on the output Deployment definition. |
| redis.architecture | string | `"replication"` |  |
| redis.auth.enabled | bool | `true` |  |
| redis.custom.backup.concurrencyPolicy | string | `""` | Concurrency Policy |
| redis.custom.backup.enabled | bool | `true` | Enable Backup Job |
| redis.custom.backup.failedJobsHistoryLimit | int | `3` | Failed Jobs History Limit |
| redis.custom.backup.persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{"helm.sh/resource-policy":"keep"},"enabled":true,"labels":{},"size":"3Gi","storageClass":""}` | Persistence Configuration |
| redis.custom.backup.persistence.accessModes | list | `["ReadWriteOnce"]` | Access Modes |
| redis.custom.backup.persistence.annotations | object | `{"helm.sh/resource-policy":"keep"}` | Annotations for the persistence |
| redis.custom.backup.persistence.enabled | bool | `true` | Enable Persistence |
| redis.custom.backup.persistence.labels | object | `{}` | Labels for the persistence |
| redis.custom.backup.persistence.size | string | `"3Gi"` | Path for the persistence |
| redis.custom.backup.persistence.storageClass | string | `""` | StorageClass |
| redis.custom.backup.restartPolicy | string | `"OnFailure"` | RestartPolicy |
| redis.custom.backup.retentionDays | int | `7` | Retention in Revisions for the backup |
| redis.custom.backup.schedule | string | `"* * * * *"` | Schedule For Backup Job |
| redis.custom.backup.successfulJobsHistoryLimit | int | `1` | Successful Jobs History Limit |
| redis.custom.backup.ttlSecondsAfterFinished | int | `60` | Time to live for the job |
| redis.custom.config | object | `{}` | Custom Redisson Configuration ([Reference](https://github.com/redisson/redisson/wiki/2.-Configuration/)) |
| redis.custom.database | int | `0` | Redis Database-Key |
| redis.custom.helper.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| redis.custom.helper.image.registry | string | `"docker.io"` | Image Registry |
| redis.custom.helper.image.repository | string | `"bitnami/redis-sentinel"` | Image Repository |
| redis.custom.helper.image.tag | string | `"7.2.5-debian-12-r0"` | Image Tag |
| redis.custom.helper.podSecurityContext | object | `{"enabled":true,"fsGroup":1001,"seccompProfile":{"type":"RuntimeDefault"}}` | SecurityContext for Pod |
| redis.custom.helper.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"enabled":true,"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":1001}` | SecurityContext for Container |
| redis.metrics.enabled | bool | `true` |  |
| redis.metrics.extraArgs.skip-tls-verification | bool | `true` |  |
| redis.sentinel.enabled | bool | `true` |  |
| redis.sentinel.masterSet | string | `"antmedia"` |  |
| redis.tls.certCAFilename | string | `"ca.pem"` |  |
| redis.tls.certFilename | string | `"cert.pem"` |  |
| redis.tls.certKeyFilename | string | `"cert.key"` |  |
| redis.tls.enabled | bool | `false` |  |
| redis.tls.existingSecret | string | `"ams-tls-secret"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | redis | 19.5.3 |
