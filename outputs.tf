output "region" {
  value = "eu-central-1"
}

output "vpc_id" {
  value = module.vpc.id
}

output "vpc_name" {
  value = local.vpc_name
}

output "vpc_cidr_block" {
  value = module.vpc.cidr_block
}

output "public_subnet_ids" {
  value = [module.vpc.public_subnet_ids]
}

output "private_subnet_ids" {
  value = [module.vpc.private_subnet_ids]
}

output "availability_zones" {
  value = local.azs
}

output "kops_s3_bucket" {
  value = aws_s3_bucket.kops_state.bucket
}

output "kubernetes_cluster_name" {
  value = local.kubernetes_cluster_name
}