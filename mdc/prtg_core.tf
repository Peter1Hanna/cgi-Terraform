provider "vsphere" {
    user           = "al.jain@mgmt.certapay.com"
  password       = "Concentr@852!"
  vsphere_server = "whtv66472.mgmt.certapay.com"
  #version = "~&gt; 1.11"
 
  # If you have a self-signed cert
  allow_unverified_ssl = true
}

variable "vsphere_compute" {
  default = "WHTQ30309 - MGMT"
}

data "vsphere_datacenter" "dc" {
  name = "Toronto"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "${var.vsphere_compute}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "VLAN105_Std"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "Windows2019_Interac_22Jun2021"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


data "vsphere_resource_pool" "pool" {
  name          = "TF"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


resource "vsphere_virtual_machine" "VM" {
  guest_id = "windows9Server64Guest"
  count = "1"
  name   = "whtm70639 - mdcmprtgqa1"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
    network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "vmxnet3" 
    }
    disk {
    label = "disk0"
    size = "${data.vsphere_virtual_machine.template.disks.0.size}"
  }
  firmware = "efi"

   clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
   }
  vcpu   = 4
  memory = 4096
  # ...
} 
