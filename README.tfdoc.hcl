header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-kubernetes-cluster-role"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-kubernetes-cluster-role/workflows/Tests/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-kubernetes-cluster-role/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-kubernetes-cluster-role.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-kubernetes-cluster-role/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/terraform-0.14.7+%20|%202-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-kubernetes-cluster-role"
  toc     = true
  content = <<-END
    A [Terraform] module for using
    [Role-based Access Control (RBAC) Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
    on [Kubernetes](https://kubernetes.io/).

    **_This module supports Terraform version 0.14.7 up to (not including) version 2.0
    and is compatible with the Terraform Kubernetes Provider version 2._**

    This module is part of our Infrastructure as Code (IaC) framework
    that enables our users and customers to easily deploy and manage reusable,
    secure, and production-grade cloud infrastructure.
  END

  section {
    title   = "Module Features"
    content = <<-END
      This module implements the following Terraform resources

      - `kubernetes_cluster_role`
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most common usage of the module:

      ```hcl
      module "terraform-kubernetes-cluster-role" {
        source = "git@github.com:mineiros-io/terraform-kubernetes-cluster-role.git?ref=v0.0.1"
      
        name = "name"
      }
      ```
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Main Resource Configuration"

      variable "name" {
        required    = true
        type        = string
        description = <<-END
          Name of the cluster role binding, must be unique. Cannot be updated.
        END
      }

      variable "annotations" {
        type        = map(string)
        description = <<-END
          An unstructured key value map stored with the cluster role binding
          that may be used to store arbitrary metadata. 
        END
      }

      variable "labels" {
        type        = map(string)
        description = <<-END
          Map of string keys and values that can be used to organize and
          categorize (scope and select) the cluster role binding.
        END
      }

      variable "rules" {
        type        = list(rule)
        description = <<-END
          List of rules that define the set of permissions for this role.
        END

        attribute "api_groups" {
          type        = list(string)
          description = <<-END
            APIGroups is the name of the APIGroup that contains the resources.
            If multiple API groups are specified, any action requested against
            one of the enumerated resources in any API group will be allowed.
          END
        }

        attribute "non_resource_urls" {
          type        = list(string)
          description = <<-END
            `NonResourceURLs` is a set of partial urls that a user should have
            access to. `*s` are allowed, but only as the full, final step in the
            path Since non-resource URLs are not namespaced, this field is only
            applicable for `ClusterRoles` referenced from a `ClusterRoleBinding`.
            Rules can either apply to API resources (such as "pods" or "secrets")
            or non-resource URL paths (such as "/api"), but not both.
          END
        }

        attribute "resource_names" {
          type        = list(string)
          description = <<-END
           `ResourceNames` is an optional white list of names that the rule
            applies to. An empty set means that everything is allowed.
          END
        }

        attribute "resources" {
          type        = list(string)
          description = <<-END
            Resources is a list of resources this rule applies to. `ResourceAll`
            represents all resources.
          END
        }

        attribute "verbs" {
          required    = true
          type        = list(string)
          description = <<-END
            `Verbs` is a list of Verbs that apply to ALL the `ResourceKinds` and
            `AttributeRestrictions` contained in this rule. `VerbAll` represents
            all kinds.
          END
        }
      }

      variable "aggregation_rule" {
        type        = object(aggregation_rule)
        description = <<-END
          Describes how to build the Rules for this `ClusterRole`. If
          `AggregationRule` is set, then the Rules are controller managed and
          direct changes to Rules will be overwritten by the controller.
        END

        attribute "cluster_role_selectors" {
          type        = list(cluster_role_selector)
          description = <<-END
            A list of selectors which will be used to find ClusterRoles and
            create the rules.
          END

          attribute "match_labels" {
            type        = map(string)
            description = <<-END
              A map of `{key,value}` pairs. A single `{key,value}` in the
              `matchLabels` map is equivalent to an element of
              `matchExpressions`, whose key field is `key`, the operator is
              `In`, and the values array contains only `value`. The
              requirements are ANDed.
            END
          }

          attribute "match_expressions" {
            type        = list(match_expression)
            description = <<-END
              A list of label selector requirements. The requirements are ANDed.
            END

            attribute "key" {
              type        = string
              description = <<-END
                The label key that the selector applies to.
              END
            }

            attribute "operator" {
              type        = string
              description = <<-END
                A key's relationship to a set of values. Valid operators are
                `In`, `NotIn`, `Exists` and `DoesNotExist`.
              END
            }

            attribute "values" {
              type        = set(string)
              description = <<-END
                An array of string values. If the operator is `In` or `NotIn`,
                the values array must be non-empty. If the operator is `Exists`
                or `DoesNotExist`, the values array must be empty. This array is
                replaced during a strategic merge patch.
              END
            }
          }
        }
      }
    }

    section {
      title = "Module Configuration"

      variable "module_enabled" {
        type        = bool
        default     = true
        description = <<-END
          Specifies whether resources in the module will be created.
        END
      }

      variable "module_depends_on" {
        type           = list(dependency)
        description    = <<-END
          A list of dependencies.
          Any object can be _assigned_ to this list to define a hidden external dependency.
        END
        default        = []
        readme_example = <<-END
          module_depends_on = [
            null_resource.name
          ]
        END
      }
    }
  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported in the outputs of the module:
    END

    output "role" {
      type        = object(role)
      description = <<-END
        All role attributes.
      END
    }

    output "module_enabled" {
      type        = bool
      description = <<-END
        Whether this module is enabled.
      END
    }
  }

  section {
    title = "External Documentation"

    section {
      title   = "Kubernetes Documentation"
      content = <<-END
        - https://kubernetes.io/docs/reference/access-authn-authz/rbac/
      END
    }

    section {
      title   = "Terraform Kubernetes Provider Documentation"
      content = <<-END
        - https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-kubernetes-cluster-role"
  }
  ref "hello@mineiros.io" {
    value = "mailto:hello@mineiros.io"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "releases-aws-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-aws/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://mineiros.io/slack"
  }
  ref "terraform" {
    value = "https://www.terraform.io"
  }
  ref "aws" {
    value = "https://aws.amazon.com/"
  }
  ref "semantic versioning (semver)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-kubernetes-cluster-role/blob/main/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-kubernetes-cluster-role/blob/main/examples"
  }
  ref "issues" {
    value = "https://github.com/mineiros-io/terraform-kubernetes-cluster-role/issues"
  }
  ref "license" {
    value = "https://github.com/mineiros-io/terraform-kubernetes-cluster-role/blob/main/LICENSE"
  }
  ref "makefile" {
    value = "https://github.com/mineiros-io/terraform-kubernetes-cluster-role/blob/main/Makefile"
  }
  ref "pull requests" {
    value = "https://github.com/mineiros-io/terraform-kubernetes-cluster-role/pulls"
  }
  ref "contribution guidelines" {
    value = "https://github.com/mineiros-io/terraform-kubernetes-cluster-role/blob/main/CONTRIBUTING.md"
  }
}
