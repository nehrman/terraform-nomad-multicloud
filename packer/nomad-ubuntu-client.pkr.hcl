#################
#               #
# AWS Variables #
#               #
#################

variable "aws_region" {
  type = string
  default = "eu-west-1"
}

variable "aws_instance_type" {
  type = string
  default = "t2.micro"
}

###################
#                 #
# Azure Variables #
#                 #
###################

variable "client_id" {
  default = "3feca6b7-0835-4f5f-89b2-815a6fa75211"
}
variable "client_secret" {
  default = "FN7RS8AwF.___9l5GaQMrvTxQ99i5D1~2r"
}

variable "resource_group" {
  type = string
  default = "neh-packer-build"
}

variable "subscription_id" {
  default = "14692f20-9428-451b-8298-102ed4e39c2a"
}

variable "tenant_id" {
  default = "0e3e2e88-8caf-41ca-b4da-e3b33b6c52ec"
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

variable "owner" {
  type = string
  default = "neh"
}

# CREATING AWS NOMAD / CONSUL PACKER IMAGE

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
    Owner         = var.owner
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

provisioner "file" {
    source      = "../cbr/"
    destination = "/cbr"
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
    Owner         = var.owner
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

  provisioner "file" {
    source      = "../cbr/"
    destination = "/cbr"
  }
}