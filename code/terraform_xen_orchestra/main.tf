# Instruct terraform to download the provider on `terraform init`
terraform {
  required_providers {
    # https://registry.terraform.io/providers/terra-farm/xenorchestra/latest/docs  
    xenorchestra = {
      source  = "terra-farm/xenorchestra"
      version = "~> 0.4.2"
    }
  }
}

# Configure the XenServer Provider
provider "xenorchestra" {
  url      = var.xoa_url       # Or set XOA_URL environment variable
  username = var.xoa_username  # Or set XOA_USER environment variable
  password = var.xoa_password  # Or set XOA_PASSWORD environment variable
}

data "xenorchestra_pool" "pool" {
  
    #  The name of the POOL you want to look up.
    #  TerraForm will lookup the POOL based on this label
    name_label = "MICZONE-SRV01" 
}

data "xenorchestra_sr" "local_storage" {

  #  Your storage-repository-label to lookup
  #  TerraForm will lookup the storage based on this label
  name_label = "Local storage" 
}

data "xenorchestra_network" "net" {

  #  The name of the network to lookup
  #  TerraForm will lookup the network based on this label
  name_label = "Pool-wide network associated with eth0"
}

#data "xenorchestra_pif" "eth0" {
#  device = "eth0"
#  vlan   = -1
#}

data "xenorchestra_template" "baseOS" {

  #  The name of the NETWORK to lookup
  #  TerraForm will lookup the network based on this label
  name_label = "Fedora CoreOS"
}


resource "xenorchestra_cloud_config" "base" {
  name = "cloudconfig"
  template = <<EOF
#cloud-init
timezone: Asia/Ho_Chi_Minh
package_update: true
package_upgrade: true
users:
  - name: test
    gecos: Test User
    groups: sudo
    passwd: test
    sudo: ['ALL=(ALL) NOPASSWD:ALL']

runcmd:
 - [ ls, -l, / ]
 - [ sh, -xc, "echo $(date) ': hello world!'" ]
 - [ sh, -c, echo "=========hello world'=========" ]
 - ls -l /root
EOF
}

resource "xenorchestra_vm" "k8master" {
  count            = var.num_k8masters
  memory_max       = 4294967296
  cpus             = 2
  name_label       = "K8s Master ${count.index}"
  name_description = "K8s Master ${count.index}"
  template         = data.xenorchestra_template.baseOS.id
  cloud_config     = xenorchestra_cloud_config.base.template
  core_os          = true
  auto_poweron     = true
   
  network {
    network_id = data.xenorchestra_network.net.id
  }

  disk {
    sr_id      = data.xenorchestra_sr.local_storage.id
    name_label = "K8s Master"
    size       = 32212254720 # 32Gb
  }
}


resource "xenorchestra_vm" "k8minion" {
  # number of k8-nodes
  # this is a loop
  # https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9
  count            = var.num_k8minions 

  memory_max       = 4294967296 # 4GB
  cpus             = 2
  name_label       = "K8s Minion ${count.index}"
  name_description = "K8s Minion ${count.index}"
  template         = data.xenorchestra_template.baseOS.id
  cloud_config     = xenorchestra_cloud_config.base.template
  core_os          = true
  auto_poweron     = true


  network {
    network_id = data.xenorchestra_network.net.id
  }

  disk {
    sr_id      = data.xenorchestra_sr.local_storage.id
    name_label = "K8s Minion ${count.index}"
    size       = 32212254720 # 32Gb
  }
}
