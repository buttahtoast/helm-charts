# Contributing Guidelines

We'd love to accept your patches and contributions to this project. There are just a few small guidelines you need to follow.

# How to Contribute

With these steps you can make a contribution:

  1. Fork this repository, develop and test your changes on that fork.
  2. All commits have a meaningful description and are signed off as described above.
  3. Submit a pull request from your fork to this project.

## Code reviews

All submissions, including submissions by project members, require review. We use GitHub pull requests for this purpose. Consult [GitHub Help](https://help.github.com/articles/about-pull-requests/) for more information on using pull requests. See the above stated requirements for PR on this project.

## Technical Requirements

Your PR has to fulfill the following points, to be considered:

  * All Workflows must pass
  * DCO Check must pass
  * The title of the PR starts with the chart name (e.g. `[chart_name]: Additional options for SecurityContext`)
  * Changes must follow [Helm best practices](https://helm.sh/docs/chart_best_practices/).
  * Changes to a chart require a version bump for that chart following [semver standard](https://semver.org/).
  * New/Changed Configurations for the chart are documented in it's `README.md.gotmpl` file.

# Chart Requirements

There are certain requirements charts have to match, to be maintained in your Helm Repository. Most of the requirements are relevant when you are planning to add a new chart to the repository.

## Manifests Library

**Important**: All of the maintained charts in this repository should make use of the [Bedag Manifests Library](./charts/manifests). There might be exceptions.

When adding the Bedag Manifests Library as dependency, we don't add it as local dependency (aka via `file://..`) since the library itself has dependencies, which are not included that way. Therefor you must declare the dependency from the repository itself:

```
dependencies:
  - name: manifests
    version: "~0.4.0"
    repository: https://bedag.github.io/helm-charts/
```

## Documentation

The documentation for each chart is done with [helm-docs](https://github.com/norwoodj/helm-docs). This way we can ensure that values are consistent with the chart documentation.

**NOTE**: When creating your own `README.md.gotmpl`, don't forget to add it to your `.helmignore` file.

### Major Changes

Your chart should have a dedicated documentation part, where major changes to the chart are mentioned which cause a new major release. Here's a little example on how you could do that:

```
# Major Changes

Major Changes are documented with the version affected. **Before upgrading to a new version, check this section out!**

| **Chart Version** | **Change/Description** | **Commits/PRs** |
| :---------------- | :--------------------- | :-------------- |
||||
```

### Upgrades

If your chart requires manual interaction for version upgrades (might be the case for major upgrades) you need to mention the exact instructions in a dedicated documentation part of your chart. That's not the case for upgrades, where no specific interaction is required.


## Dependencies

Dependency versions should be set to a fixed version. We allow version fixing over all bugfix versions (eg. `~1.0.0`), since bugfix releases should not have big impact.

```
dependencies:
- name: "apache"
  version: "~1.3.0"
  repository: "https://charts.bitnami.com/bitnami"
```

There might be cases where this rule can not be applied, we are open to discuss that.


## ArtifactHub Annotations

Since we release our charts on [Artifacthub](https://artifacthub.io/) we encourage making use of the provided chart annotations for Artifacthub.

  * [All Artifacthub Annotations](https://github.com/artifacthub/hub/blob/master/docs/helm_annotations.md)

In some cases they might not be required.

### Prerelease

Annotation to mark chart release as prerelease:

```
annotations:
  artifacthub.io/prerelease: "true"
```

### SecurityUpdates

Annotation to mark that chart release contains security updates:

```
annotations:
  artifacthub.io/containsSecurityUpdates: "true"
```

### Changelog

Changes on a chart must be documented in a chart specific changelog. For every new release the entire ```artifacthub.io/changes``` needs to be rewritten. Each change requires a new bullet point following the pattern `- "[{type}]: {description}"`. Please use the following template:


```
artifacthub.io/changes: |
  - "[Added]: Something New was added"
  - "[Changed]: Changed Something within this chart"
  - "[Changed]: Changed Something else within this chart"
  - "[Deprecated]: Something deprecated"
  - "[Removed]: Something was removed"
  - "[Fixed]: Something was fixed"
  - "[Security]": Some Security Patch was included"
```
