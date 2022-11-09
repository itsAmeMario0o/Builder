resource "random_pet" "prefix" {}

resource "azurerm_resource_group" "default" {
  name     = "${random_pet.prefix.id}-rg"
  location = var.location.value
}

resource "azurerm_virtual_network" "default" {
  name                = "${random_pet.prefix.id}-vnet"
  location            = var.location.value
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.0.0.0/8"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "${random_pet.prefix.id}-subnet"
  virtual_network_name = azurerm_virtual_network.default.name
  resource_group_name  = azurerm_resource_group.default.name
  address_prefixes     = ["10.1.0.0/16"]      
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "${random_pet.prefix.id}-aks"
  location            = var.location.value
  resource_group_name = azurerm_resource_group.default.name
  kubernetes_version = "1.22.15"
  dns_prefix          = "${random_pet.prefix.id}-k8s"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
    vnet_subnet_id  = resource.azurerm_subnet.subnet.id
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

   network_profile {
    load_balancer_sku  = "standard"
    outbound_type      = "loadBalancer"
    network_plugin     = "azure"
    network_policy     = "calico"
  }

  tags = {
    Environment = "Prod"
    owner       = "mariorui"
  }
}