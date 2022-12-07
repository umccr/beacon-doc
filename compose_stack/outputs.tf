output "beacon_endpoint" {
  value = aws_route53_record.beacon_rr.name
}

output "alb_dns_name" {
  value = aws_lb.beacon_compose_alb.dns_name
}

output "instance_id" {
  value = module.beacon_compose_instance.id
}

output "instance_public_dns" {
  value = module.beacon_compose_instance.public_dns
}

output "instance_public_ip" {
  value = module.beacon_compose_instance.public_ip
}

output "instance_private_dns" {
  value = module.beacon_compose_instance.private_dns
}

output "instance_private_ip" {
  value = module.beacon_compose_instance.private_ip
}
