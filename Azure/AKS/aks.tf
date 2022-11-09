resource "random_pet" "prefix" {}

resource "azurerm_resource_group" "default" {
  name     = "${random_pet.prefix.id}-rg"
  location = var.location.value
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "${random_pet.prefix.id}-aks"
  location            = var.location.value
  resource_group_name = azurerm_resource_group.default.name
  kubernetes_version = "1.22.15"
  dns_prefix          = "${random_pet.prefix.id}-k8s"

  addon_profile {
    kube_dashboard {
      enabled = true
    }
  }
  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  role_based_access_control {
    enabled = true
  }

   network_profile {
    load_balancer_sku  = "standard"
    outbound_type      = "loadBalancer"
    network_plugin     = "azure"
    network_policy     = "calico"
  }

  tags = {
    Environment = "Prod"
  }
}