terraform {
  backend "azurerm" {
    resource_group_name  = "tf-rg"
    storage_account_name = "tfstorageacctsnehal"
    container_name       = "tfstate"
    key                  = "production.tfstate"
  }
}
