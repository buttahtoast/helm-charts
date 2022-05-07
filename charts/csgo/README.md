# CSGO Server

![Version: 0.2.1](https://img.shields.io/badge/Version-0.2.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

This is a helm chart for all the docker image variants published by [cm2network](https://hub.docker.com/r/cm2network/csgo/). Container configurations can be looked up on the referenced link.

**Homepage:** <https://github.com/CM2Walki/CSGO>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| oliverbaehler | <oliverbaehler@hotmail.com> |  |
| chifu1234 | <kk@sudo-i.net> |  |

# Install Chart

```
helm install csgo --set persistence.enabled=false -n server
```

# Major Changes

Major Changes to functions are documented with the version affected. **Before upgrading the dependency version, check this section out!**

| **Template** | **Chart Version** | **Change/Description** | **Commits/PRs** |
| :----------- | :---------------- | :--------------------- | :-------------- |
|||||

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| commonLabels | object | `{}` | Common Labels are added to each kubernetes resource manifest. But will not be added to resources rendered by the common chart (eg. JMX Exporter) |
| config.additional_args | list | `[]` | `ADDITIONAL_ARGS` Configuration - Adaitional execution arguments |
| config.game.mode | int | `1` | `SRCDS_GAMEMODE` Configuration - [Game Mode](https://developer.valvesoftware.com/wiki/CSGO_Game_Mode_Commands) |
| config.game.type | int | `0` | `SRCDS_GAMETYPE` Configuration - [Game Type](https://developer.valvesoftware.com/wiki/CSGO_Game_Mode_Commands) |
| config.hostname | string | `"Custom CS GO Server"` | `SRCDS_HOSTNAME` Configuration - Server hostname |
| config.local_address | string | `"0"` | `SRCDS_IP` Configuration - Local address binding |
| config.map.group | string | `"mg_active"` | `SRCDS_MAPGROUP` Configuration - Active [Mapgroup](https://wiki.nitrado.net/en/CS:GO_Server_Configuration) |
| config.map.start | string | `"de_dust2"` | `SRCDS_STARTMAP` Configuration - Start Map |
| config.maxfps | int | `300` | `SRCDS_FPSMAX` Configuration - Maximum FPS |
| config.maxplayers | int | `14` |  |
| config.password | string | `""` | `SRCDS_PORT` Configuration - Published Server Port |
| config.port | int | `27015` |  |
| config.public_address | string | `"0"` | `SRCDS_NET_PUBLIC_ADDRESS` Configuration - Published address |
| config.rcon_password | string | `""` | `SRCDS_RCONPW` Configuration (Will be stored as secret) |
| config.region | int | `3` |  |
| config.tickrate | int | `128` | `SRCDS_REGION` Configuration - [Server Region](https://github.com/GameServerManagers/Game-Server-Configs/blob/master/CounterStrikeGlobalOffensive/server.cfg#L36) |
| config.workshop.auth | string | `""` | `SRCDS_WORKSHOP_AUTHKEY` Configuration - Required to use host_workshop_map |
| config.workshop.collection | int | `1` | `SRCDS_HOST_WORKSHOP_COLLECTION` Configuration - Workshop map [collection](https://developer.valvesoftware.com/wiki/CSGO_Workshop_For_Server_Operators) |
| config.workshop.start_map | int | `0` | `SRCDS_WORKSHOP_START_MAP` Configuration - Map loaded on server restart |
| extraResources | list | `[]` | Enter Extra Resources managed by the release |
| fullnameOverride | string | `""` | Overwrite "bedag-lib.fullname" output |
| global.defaultTag | string | `""` | Global Docker Image Tag declaration. Will be used as default tag, if no tag is given by child |
| global.imagePullPolicy | string | `""` | Global Docker Image Pull Policy declaration. Will overwrite all child .pullPolicy fields. |
| global.imagePullSecrets | list | `[]` | Global Docker Image Pull Secrets declaration. Added to local Docker Image Pull Secrets. |
| global.imageRegistry | string | `""` | Global Docker Image Registry declaration. Will overwrite all child .registry fields. |
| global.storageClass | string | `""` | Global StorageClass declaration. Can be used to overwrite StorageClass fields. |
| ingress.annotations | object | `{}` | Configure Ingress Annotations |
| ingress.apiVersion | string | `""` | Configure the api version used for the ingress resource. |
| ingress.backend | object | `{}` | Configure a [default backend](https://kubernetes.io/docs/concepts/services-networking/ingress/#default-backend) for this ingress resource |
| ingress.customRules | list | `[]` | Configure Custom Ingress [Rules](https://kubernetes.io/docs/concepts/services-networking/ingress/#resource-backend) |
| ingress.enabled | bool | `true` | Enable Ingress Resource |
| ingress.hosts | list | `[]` | Configure Ingress [Hosts](https://kubernetes.io/docs/concepts/services-networking/ingress/#ingress-rules) (Required) |
| ingress.ingressClass | string | `""` | Configure the [default ingress class](https://kubernetes.io/docs/concepts/services-networking/ingress/#default-ingress-class) for this ingress. |
| ingress.labels | object | `{}` | Configure Ingress additional Labels |
| ingress.tls | list | `[]` | Configure Ingress [TLS](https://kubernetes.io/docs/concepts/services-networking/ingress/#tls) |
| nameOverride | string | `""` | Overwrite "bedag-lib.name" output |
| overwriteLabels | object | `{}` | Overwrites default labels, but not resource specific labels and common labels |
| pdb.apiVersion | string | `""` | Configure the api version used for the Pdb resource |
| pdb.enabled | bool | `false` | Enable Pdb Resource |
| pdb.labels | object | `bedag-lib.commonLabels` | Merges given labels with common labels |
| pdb.maxUnavailable | string | `nil` | Number or percentage of pods which is allowed to be unavailable during a disruption |
| pdb.minAvailable | string | `nil` | Number or percentage of pods which must be available during a disruption. If neither `minAvailable` or `maxUnavailable` is set, de Policy defaults to `minAvailable: 1` |
| pdb.selectorLabels | object | `bedag-lib.selectorLabels` | Define SelectorLabels for the pdb |
| persistence.accessModes | list | `["ReadWriteOnce"]` | Configure PVC [Access Modes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes) |
| persistence.annotations | object | `{}` | Configure PVC additional Annotations |
| persistence.dataSource | string | `nil` | Data Sources are currently only supported for [CSI Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#volume-snapshot-and-restore-volume-from-snapshot-support) |
| persistence.enabled | bool | `true` | Enable Persistence |
| persistence.labels | object | `bedag-lib.commonLabels` | Merges given labels with common labels |
| persistence.mountPath | string | `"/home/steam/csgo-dedicated/"` | Destination for persistent volume |
| persistence.selector | object | `{}` | Configure PVC [Selector](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#selector) |
| persistence.size | string | `"10Gi"` | Define requested storage size |
| persistence.storageClass | string | `""` | Configure PVC [Storage Class](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#class-1) |
| proxy.httpProxy.host | string | `""` | Configure HTTP Proxy Hostname/IP (without protocol://) |
| proxy.httpProxy.port | int | `nil` | Configure HTTP Proxy Port |
| proxy.httpProxy.protocol | string | http | Configure HTTP Proxy Protocol (http/https) |
| proxy.httpsProxy.host | string | `""` | Configure HTTPS Proxy Hostname/IP (without protocol://) |
| proxy.httpsProxy.port | int | `nil` | Configure HTTPS Proxy Port |
| proxy.httpsProxy.protocol | string | http | Configure HTTPS Proxy Protocol (http/https) |
| proxy.noProxy | list | `[ "localhost", "127.0.0.1" ]` | Configure No Proxy Hosts |
| selectorLabels | object | `app.kubernetes.io/name: crowd-software<br>app.kubernetes.io/instance: test` | Define default [selectorLabels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) |
| service.annotations | object | `{}` | Configure Service additional Annotations ([Monitor Labels](https://www.weave.works/docs/cloud/latest/tasks/monitor/configuration-k8s/)) |
| service.apiVersion | string | v1 | Configure the api version used |
| service.enabled | bool | `true` | Enable Service Resource |
| service.extraPorts | list | `[]` | Add additional ports to the service |
| service.labels | object | `{}` | Configure Service additional Labels |
| service.loadBalancerIP | string | `""` | Configure Service [loadBalancerIP](https://kubernetes.io/docs/concepts/services-networking/service/#internal-load-balancer). Set the LoadBalancer service type to internal only. |
| service.loadBalancerSourceRanges | list | `[]` | Configure Service [loadBalancerSourceRanges](https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/#restrict-access-for-loadbalancer-service) |
| service.nodePort | string | `""` | Specify the nodePort value for the LoadBalancer and NodePort service types |
| service.selector | object | `bedag-lib.selectorLabels` | Configure Service Selector Labels |
| service.type | string | `"ClusterIP"` | Configure Service [Type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). |
| statefulset.affinity | object | `{}` | Pod [Affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) |
| statefulset.apiVersion | string | `""` | Configure the api version used for the Statefulset resource |
| statefulset.args | object | `{}` | Configure arguments for executed command |
| statefulset.command | object | `{}` | Configure executed container command |
| statefulset.containerFields | object | `{}` | Extra fields used on the container definition |
| statefulset.containerName | string | `.Chart.Name` | Configure Container Name |
| statefulset.environment | object | `{}` | Configure Environment Variables (Refer to values.yaml) |
| statefulset.forceRedeploy | bool | `false` |  |
| statefulset.image.pullPolicy | string | `""` | Configure Docker Pull Policy. Will be overwritten if set by global variable. |
| statefulset.image.registry | string | `"docker.io"` | Configure Docker Registry. Will be overwritten if set by global variable. |
| statefulset.image.repository | string | `"cm2network/csgo"` | Configure Docker Repository |
| statefulset.image.tag | string | `latest` | Configure Docker Image tag |
| statefulset.imagePullSecrets | list | `[]` | Define [ImagePullSecrets](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/). Will be overwritten if set by global variable. |
| statefulset.initContainers | list | `[]` | Pod [initContainers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) |
| statefulset.labels | object | `bedag-lib.commonLabels` | Merges given labels with common labels |
| statefulset.lifecycle | object | `{}` | Container [Lifecycle](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/) |
| statefulset.livenessProbe | object | `{"initialDelaySeconds":30,"periodSeconds":10,"tcpSocket":{"port":"srcds"}}` | Container [LivenessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-a-liveness-command) |
| statefulset.nodeSelector | object | `{}` | Pod [NodeSelector](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) |
| statefulset.podAnnotations | object | `{}` | Pod [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) are only added for the pod |
| statefulset.podFields | object | `{}` | Add extra field to the [Pod Template](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#podtemplate-v1-core) if not available as value. |
| statefulset.podLabels | object | `{}` | Pod [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) are only added for the pod |
| statefulset.podManagementPolicy | string | `""` | Statefulset [Management Policy](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#pod-management-policies). **Statefulset only** |
| statefulset.podSecurityContext | object | `{}` | Pod [SecurityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) |
| statefulset.ports | object | `{}` | Configure Container Ports |
| statefulset.priorityClassName | string | `""` | Pod [priorityClassName](https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass) |
| statefulset.readinessProbe | object | `{}` | Container [ReadinessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-readiness-probes) |
| statefulset.replicaCount | int | 1 | Amount of Replicas deployed |
| statefulset.resources | object | `{}` | Configure Container [Resource](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) |
| statefulset.restartPolicy | string | `nil` | Restart policy for all containers within the pod. One of Always, OnFailure, Never. Default to Always. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy |
| statefulset.rollingUpdatePartition | string | `""` | Statefulset [Update Pratition](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#partitions). **Statefulset only** |
| statefulset.securityContext | object | `{}` | Container [SecurityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) |
| statefulset.selectorLabels | object | `bedag-lib.selectorLabels` | Define SelectorLabels for the Pod Template |
| statefulset.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| statefulset.serviceAccount.apiVersion | string | v1 | Configure the api version used |
| statefulset.serviceAccount.automountServiceAccountToken | bool | `true` | (bool) AutomountServiceAccountToken indicates whether pods running as this service account should have an API token automatically mounted. |
| statefulset.serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| statefulset.serviceAccount.enabled | bool | `false` | Specifies whether a service account is enabled or not |
| statefulset.serviceAccount.globalPullSecrets | bool | `false` | Evaluate global set pullsecrets and mount, if set |
| statefulset.serviceAccount.imagePullSecrets | list | `[]` | ImagePullSecrets is a list of references to secrets in the same namespace to use for pulling any images in pods that reference this ServiceAccount. |
| statefulset.serviceAccount.labels | object | `{}` | Merges given labels with common labels |
| statefulset.serviceAccount.name | string | `bedag-lib.fullname` | If not set and create is true, a name is generated using the fullname template |
| statefulset.serviceAccount.secrets | list | `[]` | Secrets is the list of secrets allowed to be used by pods running using this ServiceAccount |
| statefulset.serviceName | string | `bedag-lib.fullname` | Define a Service for the Statefulset |
| statefulset.sidecars | list | `[]` | Allows to add sidecars to your [maincar]](https://kubernetes.io/docs/concepts/workloads/pods/#using-pods) |
| statefulset.startupProbe | object | `{}` | Container [StartupProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-startup-probes) |
| statefulset.tolerations | object | `{}` | Pod [Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |
| statefulset.updateStrategy | string | `"RollingUpdate"` | Statefulset [Update Strategy](https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/#updating-statefulsets). **Statefulset only** |
| statefulset.volumeClaimTemplates | list | `[]` | Statefulset [volumeClaimTemplates](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#components). **Statefulset only** |
| statefulset.volumeMounts | object | `{}` | Configure Container [volumeMounts](https://kubernetes.io/docs/tasks/configure-pod-container/configure-volume-storage/) |
| statefulset.volumes | list | `[]` | Additional [Volumes](https://kubernetes.io/docs/concepts/storage/volumes/) |
| timezone | string | `"Europe/Zurich"` | Define Container Timezone (Sets TZ Environment) |
| tv.enabled | bool | `true` | Enable GO broadcasting (Enables Service and Port) |
| tv.port | int | `27020` | `SRCDS_TV_PORT` Configuration - Pod port for broadcasting |
| tv.service.annotations | object | `{}` | Configure Service additional Annotations ([Monitor Labels](https://www.weave.works/docs/cloud/latest/tasks/monitor/configuration-k8s/)) |
| tv.service.apiVersion | string | v1 | Configure the api version used |
| tv.service.enabled | bool | `true` | Enable Service Resource |
| tv.service.extraPorts | list | `[]` | Add additional ports to the service |
| tv.service.labels | object | `{}` | Configure Service additional Labels |
| tv.service.loadBalancerIP | string | `""` | Configure Service [loadBalancerIP](https://kubernetes.io/docs/concepts/services-networking/service/#internal-load-balancer). Set the LoadBalancer service type to internal only. |
| tv.service.loadBalancerSourceRanges | list | `[]` | Configure Service [loadBalancerSourceRanges](https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/#restrict-access-for-loadbalancer-service) |
| tv.service.nodePort | string | `""` | Specify the nodePort value for the LoadBalancer and NodePort service types |
| tv.service.portName | string | `"srcds_tv"` | Configure Service Port name |
| tv.service.selector | object | `bedag-lib.selectorLabels` | Configure Service Selector Labels |
| tv.service.type | string | `"ClusterIP"` | Configure Service [Type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). |

## Source Code

* <https://github.com/buttahtoast/helm-charts/tree/master/charts/csgo>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://bedag.github.io/helm-charts | manifests | >= 0.4.0 < 1.0.0 |
