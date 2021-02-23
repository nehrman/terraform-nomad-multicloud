module "aws_nomad" {
    source = "./modules/aws"
    ami = "ami-0209ea39198b80568"
    key_name = "nehrman-key"
    owner_email = "nehrman@hashicorp.com"
    owner_name = "nehrman"
    region = "eu-west-1"
}

module "arm_nomad" {
    source = "./modules/azure"
    location = "West Europe"
    server_count = "3"
    client_count = "3"
    build_packer_image = false
    packer_image_name = "nomad"
    packer_image_resource_group = "neh-packer-build"
}