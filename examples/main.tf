# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# EXAMPLE FULL USAGE OF THE TERRAFORM-KUBERNETES-CLUSTER-ROLE MODULE
#
# And some more meaningful information.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

module "terraform-kubernetes-cluster-role" {
  source = "git@github.com:mineiros-io/terraform-kubernetes-cluster-role.git?ref=v0.0.1"

  # All required module arguments

  name = "reader"

  # All optional module arguments set to the default values
  # "namespace" omitted since ClusterRoles are not namespaced  
  rules=[{
    apiGroups = [""]
    resources = ["secrets"]
    verbs = ["get", "watch", "list"]
  },
  {
    apiGroups = [""]
    resources = ["pods"]
    verbs = ["get", "watch", "list"]
  }]

  # All optional module configuration arguments set to the default values.
  # Those are maintained for terraform 0.12 but can still be used in terraform 0.13
  # Starting with terraform 0.13 you can additionally make use of module level
  # count, for_each and depends_on features.
  module_enabled    = true
  module_depends_on = []
}

# ----------------------------------------------------------------------------------------------------------------------
# EXAMPLE PROVIDER CONFIGURATION
# ----------------------------------------------------------------------------------------------------------------------

provider "kubernetes" {
  version = "~> 2.0"
}

# ----------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES:
# ----------------------------------------------------------------------------------------------------------------------
# You can provide your credentials via the
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#authentication
# ----------------------------------------------------------------------------------------------------------------------