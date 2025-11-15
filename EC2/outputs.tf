# Bastion 跳板机公有 IP（本地连接用）
output "bastion_public_ip" {
  description = "Bastion 跳板机公有 IP"
  value       = aws_instance.bastion.public_ip
}

# 内网 EC2 私有 IP（通过 Bastion 访问用）
output "app_server_private_ip" {
  description = "内网 EC2（app_server）私有 IP"
  value       = aws_instance.app_server.private_ip
}

# VPC 默认安全组 ID（便于后续排查）
output "default_security_group_id" {
  description = "VPC 默认安全组 ID"
  value       = module.vpc.default_security_group_id
}
