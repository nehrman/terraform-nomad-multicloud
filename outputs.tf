output "arm_server_public_ips" {
  value = module.arm_nomad.server_public_ips
}

output "arm_server_private_ips" {
  value = module.arm_nomad.server_private_ips
}

output "arm_server_addresses" {
  value = module.arm_nomad.server_addresses
}

output "arm_server_lb_id" {
  value = module.arm_nomad.server_lb_id
}

output "arm_server_lb_public_ip" {
  value = module.arm_nomad.server_lb_public_ip
}

output "arm_clients_lb_id" {
  value = module.arm_nomad.clients_lb_id
}

output "arm_clients_lb_public_ip" {
  value = module.arm_nomad.clients_lb_public_ip
}

output "arm_nomad_addr" {
  value = module.arm_nomad.nomad_addr
}

output "arm_consul_addr" {
  value = module.arm_nomad.consul_addr
}

output "arm-client_vmss_id" {
  value = module.arm_nomad.client_vmss_id
}

output "arm_client_vmss_name" {
  value = module.arm_nomad.client_vmss_name
}

output "aws_server_tag_name" {
  value = module.aws_nomad.server_tag_name
}

output "aws_server_public_ips" {
  value = module.aws_nomad.server_public_ips
}

output "aws_server_private_ips" {
  value = module.aws_nomad.server_private_ips
}

output "aws_server_addresses" {
  value = module.aws_nomad.server_addresses
}

output "aws_server_elb_dns" {
  value = module.aws_nomad.server_elb_dns
}

output "aws_server_elb_dns_zone_id" {
  value = module.aws_nomad.server_elb_dns_zone_id
}

output "aws_client_elb_dns" {
  value = module.aws_nomad.client_elb_dns
}

output "client_elb_dns_zone_id" {
  value = module.aws_nomad.client_elb_dns_zone_id
}

output "aws_nomad_addr" {
  value = module.aws_nomad.nomad_addr
}

output "aws_hosts_file" {
  value = module.aws_nomad.hosts_file
}

output "aws_client_asg_arn" {
  value = module.aws_nomad.client_asg_arn
}

output "aws_client_asg_name" {
  value = module.aws_nomad.client_asg_name
}

output "aws_ssh_file" {
  value = module.aws_nomad.ssh_file
}
