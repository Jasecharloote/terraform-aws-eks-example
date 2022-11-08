output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "endpoint" {
  value = aws_eks_cluster.eks-prod-example.endpoint
}

locals {
  kubeconfig = <<EOF

apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.eks-prod-example.endpoint}
    certificate-authority-data: ${aws_eks_cluster.eks-prod-example.certificate_authority.0.data}
  name: ${aws_eks_cluster.eks-prod-example.arn}
contexts:
- context:
    cluster: ${aws_eks_cluster.eks-prod-example.arn}
    user: ${aws_eks_cluster.eks-prod-example.arn}
  name: ${aws_eks_cluster.eks-prod-example.arn}
current-context: ${aws_eks_cluster.eks-prod-example.arn}
kind: Config
preferences: {}
users:
- name: ${aws_eks_cluster.eks-prod-example.arn}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: aws
      args:
        - eks
        - get-token
        - --cluster-name
        - "${aws_eks_cluster.eks-prod-example.name}"
EOF
}

output "kubeconfig" {
  value = "${local.kubeconfig}"
}