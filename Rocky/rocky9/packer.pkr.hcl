packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.8"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_node" {
  type    = string
  default = ""
}

variable "proxmox_url" {
  type    = string
  default = ""
}

variable "proxmox_username" {
  type    = string
  default = ""
}

variable "proxmox_password" {
  type    = string
  default = ""
}

variable "ssh_pass" {
  type    = string
  default = ""
}
source "proxmox-iso" "rocky9-kickstart" {
  boot_command = ["<tab> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/kickstart.cfg<enter><wait>"]
  boot_wait    = "5s"
  cores        = "4"
  cpu_type     = "host"
  memory       = "4096"
  disks {
    disk_size         = "20G"
    storage_pool      = "local-lvm"
    type              = "scsi"
  }
  scsi_controller          = "virtio-scsi-single"
  http_directory           = "Rocky/rocky9/http"
  insecure_skip_tls_verify = true
  iso_file                 = "local:iso/Rocky-9.6-x86_64-dvd.iso"
  iso_checksum             = "none"
  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }
  node                 = "${var.proxmox_node}"
  proxmox_url          = "${var.proxmox_url}"
  username             = "${var.proxmox_username}"
  token                = "${var.proxmox_password}"
  ssh_username         = "ansible"
  #ssh_password         = "${var.ssh_pass}"
  ssh_password         = ""
  ssh_timeout          = "15m"
  template_description = "Rocky 9.6, generated on ${timestamp()}"
  template_name        = "rocky-9.6"
  unmount_iso          = true
}

build {
  sources = ["source.proxmox-iso.rocky9-kickstart"]
}
