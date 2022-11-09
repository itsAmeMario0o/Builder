variable "appId" {
  description = "Azure Kubernetes Service Cluster service principal"
}

variable "password" {
  description = "Azure Kubernetes Service Cluster password"
}

variable location {
    type = map(string)
    default = {
      value = "East US"
      suffix = "eastus"
    }
}