variable "xoa_url" {
  default = "ws://192.168.3.4" # Or set xen-orchestra's XOA_URL begin with ws:// or wss://
}

variable "xoa_username" {
  default = "root" # Or set xen-orchestra's XOA_URL begin with ws:// or wss://
}

variable "xoa_password" {
  default = "Admin@123456" # Or set xen-orchestra's XOA_URL begin with ws:// or wss://
}

variable "num_k8masters" {
    default = 1
}

variable "num_k8minions" {
    default = 2
}