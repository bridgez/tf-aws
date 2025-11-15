provider "aws" {
  region = "us-east-2"

  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

#  endpoints {
#    ec2        = "http://localhost:4566"
#  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-ebs"]
  }

  owners = ["137112412989"] # Amazon
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "example-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_dns_hostnames    = true  
}

# ------------------------------
# 新增：允许 SSH 访问 + 对外任意访问的安全组
# ------------------------------
resource "aws_security_group" "app_server_sg" {
  name        = "app-server-ssh-anywhere"
  description = "允许任意地址 SSH 访问（22 端口），允许实例对外访问任意地址和端口"
  vpc_id      = module.vpc.vpc_id # 关联到当前 VPC

  # 入站规则：允许任意地址访问 SSH（22 端口）
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 0.0.0.0/0 表示任意 IPv4 地址（生产环境不推荐，仅测试用）
    # 若需限制仅自己访问，替换为你的公网 IP/32（如 "123.45.67.89/32"）
  }

  # 出站规则：允许实例对外访问任意地址、任意端口、任意协议
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" 表示所有协议（TCP/UDP/ICMP 等）
    cidr_blocks = ["0.0.0.0/0"] # 任意 IPv4 地址
  }

  tags = {
    Name = "App-Server-SG"
  }
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.app_server_sg.id]
  subnet_id              = module.vpc.private_subnets[0]

  tags = {
    Name = var.instance_name
  }
}
