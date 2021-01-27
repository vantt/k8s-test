# resource "cloudstack_ssh_keypair" "ssh_vantt" {
#   name       = "vantt_ssh"
#   public_key = file("~/.ssh/id_rsa.pub")
#   #project    = "vantt_test"
# }

resource "cloudstack_instance" "web" {
  # number of k8-nodes
  # this is a loop
  # https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9
  count            = var.num_k8minions 
  
  name             = "k8minionb-${count.index}"
  service_offering = "Small Instance"
  #network_id       = "6eb22f91-7454-4107-89f4-36afcdf33021"
  template         = var.os_image_template
  zone             = var.zone
  # keypair          = "ssh_vantt"
  # project    = "vantt_test"
  user_data = file("./cloud-init/master.yml")
}