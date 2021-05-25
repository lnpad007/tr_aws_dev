locals {
  azs                    = ["eu-central-1a", "eu-central-1b"]
  environment            = "test"
  kops_state_bucket_name = "config-bucket-kops"
  tf_state_bucket_name   =  "tr-dev-challenge-tf-state"
  kubernetes_cluster_name = "chirag.tr-talent.de"
  vpc_name                = "chirag.tr-talent.de"
  ingress_ips             = "172.20.0.0/16"

}