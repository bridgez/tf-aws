# ------------------------------
# Bastion 专用安全组（最小权限）
# ------------------------------
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-security-group"
  description = "only allow from local client, and allow to private EC2 SSH"
  vpc_id      = module.vpc.vpc_id # 关联 VPC（复用 main.tf 中的 VPC 模块）

  # 入站：仅允许你的本地公网 IP 访问 22 端口（替换为你的实际 IP）
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 你的本地公网 IP/32 查询地址：https://www.ip138.com/ 
  }

  # 出站：允许 Bastion 访问外网（可选，用于更新/下载软件）
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Bastion-SG"
  }
}

# ------------------------------
# Bastion 跳板机实例（公有子网 + 公有 IP）
# ------------------------------
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id # 与内网 EC2 共用镜像（密钥兼容）
  instance_type = "t2.micro" # 免费套餐可用，足够作为跳板
  subnet_id     = module.vpc.public_subnets[0] # 部署在公有子网
  associate_public_ip_address = true # 显式分配公有 IP

  vpc_security_group_ids = [aws_security_group.bastion_sg.id] # 关联安全组
  key_name               = "ec2-key" # 必须与内网 EC2 用同一个密钥！

  # 可选：启动日志（便于排查）
  user_data = <<-EOF
              #!/bin/bash
              echo "Bastion started at $(date)" >> /var/log/bastion.log
              EOF

  tags = {
    Name = "Bastion-Host"
  }
}
