locals {
  packer_image_resource_group = var.packer_image_resource_group != "" ? var.packer_image_resource_group : azurerm_resource_group.hashistack.name
}

resource "null_resource" "packer_build" {
  count = var.build_packer_image ? 1 : 0

  depends_on = [azurerm_resource_group.hashistack]

  provisioner "local-exec" {
    command = <<EOF
cd ../../packer && \
  packer build -force \
    -var "client_id=$ARM_CLIENT_ID" \
    -var "client_secret=$ARM_CLIENT_SECRET" \
    -var "resource_group=${local.packer_image_resource_group}" \
    -var "subscription_id=$ARM_SUBSCRIPTION_ID" \
    -var "location=${var.location}" \
    -var "image_name=${var.packer_image_name}" \
    azure-packer.pkr.hcl
EOF
  }
}

data "azurerm_image" "hashistack" {
  depends_on = [null_resource.packer_build]

  name                = var.packer_image_name
  resource_group_name = local.packer_image_resource_group
}
