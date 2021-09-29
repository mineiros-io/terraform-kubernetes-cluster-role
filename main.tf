resource "kubernetes_cluster_role" "role" {
  count = var.module_enabled ? 1 : 0

  depends_on = [var.module_depends_on]

  metadata {
    annotations = var.annotations
    labels      = var.labels
    name        = var.name
  }

  dynamic "rule" {
    for_each = var.rules

    content {
      api_groups        = try(rule.value.api_groups, null)
      non_resource_urls = try(rule.value.non_resource_urls, null)
      resource_names    = try(rule.value.resource_names, null)
      resources         = try(rule.value.resources, null)
      verbs             = rule.value.verbs
    }
  }

  dynamic "aggregation_rule" {
    for_each = var.aggregation_rule != null ? [var.aggregation_rule] : []

    content {
      dynamic "cluster_role_selectors" {
        for_each = try(aggregation_rule.value.cluster_role_selectors, [])

        content {
          match_labels = try(cluster_role_selectors.value.match_labels, null)

          dynamic "match_expressions" {
            for_each = try(cluster_role_selectors.value.match_expressions, [])

            content {
              key      = try(match_expressions.value.key, null)
              operator = try(match_expressions.value.operator, null)
              values   = try(match_expressions.value.values, null)
            }
          }
        }
      }
    }
  }
}
