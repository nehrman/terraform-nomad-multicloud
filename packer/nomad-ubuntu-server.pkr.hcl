####
#
# AWS Variables  
#
#

variable "aws_region" {
  type = string
  default = "eu-west-1"
}

variable "aws_instance_type" {
  type = string
  default = "t2.micro"
}

variable "owner" {
  type = string
  default = "neh"
}

variable "client_id" {
  default = ""
}
variable "client_secret" {
  default = ""
}

variable "resource_group" {
  type = string
  default = "neh-packer-build"
}

variable "subscription_id" {
  default = ""
}

variable "tenant_id" {
  default = ""
}

variable "location" { 
  type = string
  default = "West Europe" 
}

variable "image_name" { default = "nomad" }

####################
#                  #
# Common Variables #
#                  #
####################

variable "created_email" {
  type = string
  default = "nehrman@hashicorp.com"
}
variable "created_name" {
  type = string
  default = "neh  "
}


# CREATING AWS NOMAD / CONNSUL PACKER IMAGE 
source "amazon-ebs" "ubuntu-image" {
  ami_name = "${var.owner}_{{timestamp}}"
  region = "${var.aws_region}"
  instance_type = var.aws_instance_type

  source_ami_filter {
      filters = {
        "virtualization-type" = "hvm"
        "name" = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
        "root-device-type" = "ebs"
      }

      owners = ["099720109477"]
      most_recent = true
  }

  communicator = "ssh"
  ssh_username = "ubuntu"

  tags = {
    OS_Version    = "Ubuntu"
    Release       = "18.04"
    Architecture  = "amd64"
    Created_Email = var.created_email
    Created_Name  = var.created_name
  }
}

build {
  sources = [
    "source.amazon-ebs.ubuntu-image"
  ]

  provisioner "shell" {
    inline = [
      "sudo mkdir -p /ops",
      "sudo chmod 777 /ops"
    ]
  }

  provisioner "file" {
    source      = "../shared/"
    destination = "/ops"
  }

  provisioner "shell" {
    script = "../shared/scripts/setup.sh"
  }
}


# CREATING AZURERM NOMAD / CONNSUL PACKER IMAGE

source "azure-arm" "ubuntu-image" {
  azure_tags = {
    OS_Version    = "Ubuntu"
    Release       = "18.04"
    Architecture  = "amd64"
    Created_Email = var.created_email
    Created_Name  = var.created_name
  }

  client_id                         = "${var.client_id}"
  client_secret                     = "${var.client_secret}"
  image_offer                       = "UbuntuServer"
  image_publisher                   = "Canonical"
  image_sku                         = "18.04-LTS"
  location                          = "${var.location}"
  managed_image_name                = "${var.image_name}"
  managed_image_resource_group_name = "${var.resource_group}"
  os_type                           = "Linux"
  ssh_username                      = "packer"
  subscription_id                   = "${var.subscription_id}"
}

build {
  sources = [
    "source.azure-arm.ubuntu-image"
  ]

  provisioner "shell" {
    inline = [
      "sudo mkdir -p /ops",
      "sudo chmod 777 /ops"
    ]
  }

  provisioner "file" {
    source      = "../shared/"
    destination = "/ops"
  }

  provisioner "shell" {
    script = "../shared/scripts/setup.sh"
  }
}