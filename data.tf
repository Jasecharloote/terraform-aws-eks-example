data "tls_certificate" "oidc-certificate" {
  url = aws_eks_cluster.eks-prod-example.identity.0.oidc.0.issuer
}

data "aws_caller_identity" "current" {}
