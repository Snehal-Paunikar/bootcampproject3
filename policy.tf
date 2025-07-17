resource "azurerm_policy_definition" "require_env_tag" {
  name         = "require-environment-tag"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Require environment tag on resources"

  policy_rule = <<POLICY
{
  "if": {
    "field": "tags.environment",
    "exists": "false"
  },
  "then": {
    "effect": "deny"
  }
}
POLICY
}

resource "azurerm_policy_assignment" "require_env_tag_assignment" {
  name                 = "require-environment-tag-assignment"
  scope                = azurerm_resource_group.rg.id
  policy_definition_id = azurerm_policy_definition.require_env_tag.id
  description          = "Ensure all resources have environment tag"
  display_name         = "Require environment tag assignment"
}
