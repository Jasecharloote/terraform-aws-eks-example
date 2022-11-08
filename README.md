# terraform-aws-eks-example

Terraform eks creation scripts for aws china cloud

## Introduction

This example provisions the following resources:

- IAM Role `ProdEKSServiceRole` allows the cluster to access other AWS services
- IAM Role `ProdPolicyForEKSOIDCServiceRole` allows the `aws-ingress-load-blancer` to create AWS services, for example eks ingress resources in kubernetes
- IAM Openid connect provider `eks_oidc_provider` verifies the IAM Role `ProdPolicyForEKSOIDCServiceRole`
- IAM Policy `AWSLoadBalancerControllerIAMPolicy` defines the rights of `ProdPolicyForEKSOIDCServiceRole`
- EKS Cluster resource `eks-prod-example`
- EKS Node group `eks-node-group-prod-example`
- VPC resources
- Subnet resources

# Author

[Jasecharloote](https://github.com/Jasecharloote)

# Goal

Create EKS in AWS China region, and using OIDC mode as the trust provider from AWS

# Requirements

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.3.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.38.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 4.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.38.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.eks-prod-example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_iam_openid_connect_provider.eks_oidc_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.iam_prod_eks_service_policy_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.iam_prod_eks_service_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.iam_prod_eks_service_oidc_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.iam_prod_eks_service_policy_oidc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.iam_prod_eks_service_policy_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.iam_prod_eks_service_policy_eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.iam_prod_eks_service_policy_eks_vpc_resource_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.iam_prod_eks_service_policy_eks_cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.iam_prod_eks_service_policy_eks_ec2_container_registery_ro](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [tls_certificate.oidc-certificate](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |
