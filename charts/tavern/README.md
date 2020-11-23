# tavern

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.11.1](https://img.shields.io/badge/AppVersion-1.11.1-informational?style=flat-square)

Unofficial Tavern Helm Chart

**Homepage:** <https://tavern.readthedocs.io/en/latest/>

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
| affinity | object | `{}` |  |
| cronjob.enabled | bool | `true` |  |
| extraResources | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"nginx"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths | list | `[]` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `nil` |  |
| stageTemplates[0].name | string | `"http_basic"` |  |
| stageTemplates[0].template | string | `"request:\n  url: \"{host}/users/{{ $.tavern.endpoint }}\"\n  verify: false\n  method: GET\n  auth:\n    - \"{tavern.env_vars.KIBANA_USER}\"\n    - \"{tavern.env_vars.KIBANA_PASSWORD}\"\n  json:\n    test: true\n  headers:\n    content-type: application/json\nresponse:\n  status_code:\n    - 200\n    - 404\n"` |  |
| stageTemplates[0].values.SOMETHING_HERE | string | `"a"` |  |
| testTemplates[0].name | string | `"http_stage"` |  |
| testTemplates[0].template | string | `"\nincludes:\n  - !include common.yaml\n\nstages:\n\n  ## Straight Test\n  - name: \"Try to get user\"\n    stage:\n      request:\n        url: \"{host}/users/joebloggs\"\n        method: GET\n      response:\n        status_code:\n          - 200\n          - 404\n\n  ## Use Template\n  - name: \"test_name\"\n    template: \"http_basic\"\n    values:\n      endpoint: \"Products\"\n    stage:\n      request:\n        verify: true\n\n  ## Use Template\n  - name: \"WHERE ME\"\n    template: \"http_basic\"\n    values:\n      endpoint: \"Products\"\n    stage:\n      request:\n        verify: true\n"` |  |
| testTemplates[0].values | object | `{}` |  |
| tests[0].name | string | `"Template Suite"` |  |
| tests[0].secret | bool | `true` |  |
| tests[0].template | string | `"http_stage"` |  |
| tests[0].test.stages[0].name | string | `"test_name"` |  |
| tests[0].test.stages[0].stage.test | string | `"me"` |  |
| tests[0].values.enable_products | bool | `true` |  |
| tests[1].name | string | `"Sample Suite"` |  |
| tests[1].test.stages[0].name | string | `"Try to get user"` |  |
| tests[1].test.stages[0].stage.request.json.clusterName | string | `"test"` |  |
| tests[1].test.stages[0].stage.request.method | string | `"GET"` |  |
| tests[1].test.stages[0].stage.request.url | string | `"{host}/users/joebloggs"` |  |
| tests[1].test.stages[0].stage.response.status_code[0] | int | `200` |  |
| tests[1].test.stages[0].stage.response.status_code[1] | int | `404` |  |
| tests[1].test.stages[1].name | string | `"Some Stage"` |  |
| tests[1].test.stages[1].stage.request.verify | bool | `true` |  |
| tests[1].test.stages[1].template | string | `"http_basic"` |  |
| tests[1].test.stages[1].values.endpoint | string | `"Products"` |  |
| tolerations | list | `[]` |  |
