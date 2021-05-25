resource "aws_s3_bucket" "kops_state" {
  bucket        = local.kops_state_bucket_name
  acl           = "private"
  force_destroy = true
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = local.tf_state_bucket_name
  acl           = "private"
  force_destroy = true
}

## ECR repo

resource "aws_ecr_repository" "tr_talent" {
  name                 = "tr_dev"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

####################################

module "vpc" {
  source = "./modules/vpc"
  name = local.vpc_name
  region = var.region
  cidr_block = local.ingress_ips
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  availability_zones = var.az
  bastion_ami = "ami-043097594a7df80ec"
  key_name = "tr_devops"
  bastion_ebs_optimized = true
  bastion_instance_type = "t3.micro"
  project = "dev_challenge"
  environment = local.environment
  tags = {}
}

resource "aws_security_group" "ssh_ingress" {
  vpc_id = module.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    #cidr_blocks = [var.bastion_inbound_cidr_block]
    cidr_blocks = ["37.120.50.230/32"]
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.ssh_ingress.id
  network_interface_id = module.vpc.bastion_network_interface_id
}
