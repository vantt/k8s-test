variable "cloudstack_api_url" {
  default = "http://192.168.1.100:8080/client/api" # Or set xen-orchestra's XOA_URL begin with ws:// or wss://
}

variable "cloudstack_api_key" {
  # vantt
  # default = "t_TOEf4S2CDqVYSJIrxq14kzGekC4MLum2RDTwroGxy37cnyga99-cfQ0bcC7Z_kWsVdB2Sv2W9YCkFUnSsX4Q" # Or set xen-orchestra's XOA_URL begin with ws:// or wss://
  
  # admin 
  default = "ht1AlOi4SMgOfj4mXKJFoanKMOQ7hgryO0luIicWZ85X9-7UsJzN9D1dhNNur_zTSuCNTrh4bUoDdcHymFonxQ"
}

variable "cloudstack_secret_key" {
  # vantt
  # default = "AiH7KO3zENrcsFToz98u11uFfMSlxyVYdObEQ8g4rLS-WnTxPGKU9g8sablhkc1yN9rr3cVSzkHhPTN8N4ybgw" # Or set xen-orchestra's XOA_URL begin with ws:// or wss://
  
  # admin
  default = "k3arU18MivWU1ta-0fKg3_ngUsnbtt8DlAoa0Lh6UJnB3aHdkcQQYt9ujS2uMtHARxoAXzAaWyzj00ktve3Ijg"
}

variable "zone" {
  default = "zone-01"
}

variable "os_image_template" {
  #default = "rancheros-vmware"
  default = "Debian10_CloudInit"
}

variable "num_k8masters" {
    default = 1
}

variable "num_k8minions" {
    default = 1
}