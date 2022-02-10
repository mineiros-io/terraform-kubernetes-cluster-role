[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-kubernetes-cluster-role)

[![Build Status](https://github.com/mineiros-io/terraform-kubernetes-cluster-role/workflows/Tests/badge.svg)](https://github.com/mineiros-io/terraform-kubernetes-cluster-role/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-kubernetes-cluster-role.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-kubernetes-cluster-role/releases)
[![Terraform Version](https://img.shields.io/badge/terraform-0.14.7+%20|%202-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-kubernetes-cluster-role

A [Terraform] module for using
[Role-based Access Control (RBAC) Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
on [Kubernetes](https://kubernetes.io/).

**_This module supports Terraform version 0.14.7 up to (not including) version 2.0
and is compatible with the Terraform Kubernetes Provider version 2._**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.


- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Main Resource Configuration](#main-resource-configuration)
  - [Module Configuration](#module-configuration)
- [Module Outputs](#module-outputs)
- [External Documentation](#external-documentation)
  - [Kubernetes Documentation](#kubernetes-documentation)
  - [Terraform Kubernetes Provider Documentation](#terraform-kubernetes-provider-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

This module implements the following Terraform resources

- `kubernetes_cluster_role`

## Getting Started

Most common usage of the module:

```hcl
module "terraform-kubernetes-cluster-role" {
  source = "git@github.com:mineiros-io/terraform-kubernetes-cluster-role.git?ref=v0.0.1"
      
  name = "name"
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Main Resource Configuration

- [**`name`**](#var-name): *(**Required** `string`)*<a name="var-name"></a>

  Name of the cluster role binding, must be unique. Cannot be updated.

- [**`annotations`**](#var-annotations): *(Optional `map(string)`)*<a name="var-annotations"></a>

  An unstructured key value map stored with the cluster role binding
  that may be used to store arbitrary metadata.

- [**`labels`**](#var-labels): *(Optional `map(string)`)*<a name="var-labels"></a>

  Map of string keys and values that can be used to organize and
  categorize (scope and select) the cluster role binding.

- [**`rules`**](#var-rules): *(Optional `list(rule)`)*<a name="var-rules"></a>

  List of rules that define the set of permissions for this role.

  Each `rule` object in the list accepts the following attributes:

  - [**`api_groups`**](#attr-rules-api_groups): *(Optional `list(string)`)*<a name="attr-rules-api_groups"></a>

    APIGroups is the name of the APIGroup that contains the resources.
    If multiple API groups are specified, any action requested against
    one of the enumerated resources in any API group will be allowed.

  - [**`non_resource_urls`**](#attr-rules-non_resource_urls): *(Optional `list(string)`)*<a name="attr-rules-non_resource_urls"></a>

    `NonResourceURLs` is a set of partial urls that a user should have
    access to. `*s` are allowed, but only as the full, final step in the
    path Since non-resource URLs are not namespaced, this field is only
    applicable for `ClusterRoles` referenced from a `ClusterRoleBinding`.
    Rules can either apply to API resources (such as "pods" or "secrets")
    or non-resource URL paths (such as "/api"), but not both.

  - [**`resource_names`**](#attr-rules-resource_names): *(Optional `list(string)`)*<a name="attr-rules-resource_names"></a>

    ResourceNames is an optional white list of names that the rule
    applies to. An empty set means that everything is allowed.

  - [**`resources`**](#attr-rules-resources): *(Optional `list(string)`)*<a name="attr-rules-resources"></a>

    Resources is a list of resources this rule applies to. `ResourceAll`
    represents all resources.

  - [**`verbs`**](#attr-rules-verbs): *(**Required** `list(string)`)*<a name="attr-rules-verbs"></a>

    Verbs is a list of Verbs that apply to ALL the `ResourceKinds` and
    `AttributeRestrictions` contained in this rule. `VerbAll` represents
    all kinds.

- [**`aggregation_rule`**](#var-aggregation_rule): *(Optional `object(aggregation_rule)`)*<a name="var-aggregation_rule"></a>

  Describes how to build the Rules for this `ClusterRole`. If
  `AggregationRule` is set, then the Rules are controller managed and
  direct changes to Rules will be overwritten by the controller.

  The `aggregation_rule` object accepts the following attributes:

  - [**`cluster_role_selectors`**](#attr-aggregation_rule-cluster_role_selectors): *(Optional `list(cluster_role_selector)`)*<a name="attr-aggregation_rule-cluster_role_selectors"></a>

    A list of selectors which will be used to find ClusterRoles and
    create the rules.

    Each `cluster_role_selector` object in the list accepts the following attributes:

    - [**`match_labels`**](#attr-aggregation_rule-cluster_role_selectors-match_labels): *(Optional `map(string)`)*<a name="attr-aggregation_rule-cluster_role_selectors-match_labels"></a>

      A map of `{key,value}` pairs. A single `{key,value}` in the
      `matchLabels` map is equivalent to an element of
      `matchExpressions`, whose key field is `key`, the operator is
      `In`, and the values array contains only `value`. The
      requirements are ANDed.

    - [**`match_expressions`**](#attr-aggregation_rule-cluster_role_selectors-match_expressions): *(Optional `list(match_expression)`)*<a name="attr-aggregation_rule-cluster_role_selectors-match_expressions"></a>

      A list of label selector requirements. The requirements are ANDed.

      Each `match_expression` object in the list accepts the following attributes:

      - [**`key`**](#attr-aggregation_rule-cluster_role_selectors-match_expressions-key): *(Optional `string`)*<a name="attr-aggregation_rule-cluster_role_selectors-match_expressions-key"></a>

        The label key that the selector applies to.

      - [**`operator`**](#attr-aggregation_rule-cluster_role_selectors-match_expressions-operator): *(Optional `string`)*<a name="attr-aggregation_rule-cluster_role_selectors-match_expressions-operator"></a>

        A key's relationship to a set of values. Valid operators are
        `In`, `NotIn`, `Exists` and `DoesNotExist`.

      - [**`values`**](#attr-aggregation_rule-cluster_role_selectors-match_expressions-values): *(Optional `set(string)`)*<a name="attr-aggregation_rule-cluster_role_selectors-match_expressions-values"></a>

        An array of string values. If the operator is `In` or `NotIn`,
        the values array must be non-empty. If the operator is `Exists`
        or `DoesNotExist`, the values array must be empty. This array is
        replaced during a strategic merge patch.

### Module Configuration

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(dependency)`)*<a name="var-module_depends_on"></a>

  A list of dependencies.
  Any object can be _assigned_ to this list to define a hidden external dependency.

  Default is `[]`.

  Example:

  ```hcl
  module_depends_on = [
    null_resource.name
  ]
  ```

## Module Outputs

The following attributes are exported in the outputs of the module:

- [**`role`**](#output-role): *(`object(role)`)*<a name="output-role"></a>

  All role attributes.

- [**`module_enabled`**](#output-module_enabled): *(`bool`)*<a name="output-module_enabled"></a>

  Whether this module is enabled.

## External Documentation

### Kubernetes Documentation

- https://kubernetes.io/docs/reference/access-authn-authz/rbac/

### Terraform Kubernetes Provider Documentation

- https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-kubernetes-cluster-role
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[releases-aws-provider]: https://github.com/terraform-providers/terraform-provider-aws/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
[terraform]: https://www.terraform.io
[aws]: https://aws.amazon.com/
[semantic versioning (semver)]: https://semver.org/
[variables.tf]: https://github.com/mineiros-io/terraform-kubernetes-cluster-role/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-kubernetes-cluster-role/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-kubernetes-cluster-role/issues
[license]: https://github.com/mineiros-io/terraform-kubernetes-cluster-role/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-kubernetes-cluster-role/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-kubernetes-cluster-role/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-kubernetes-cluster-role/blob/main/CONTRIBUTING.md
