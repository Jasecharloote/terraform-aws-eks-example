resource "aws_eks_cluster" "eks-prod-example" {
  name     = "eks-prod-example"
  role_arn = aws_iam_role.iam_prod_eks_service_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.subnet-prod-tire-2-app-1a.id, aws_subnet.subnet-prod-tire-2-app-1b.id]
  }

  tags = merge(
      local.common_tags,
      tomap({
          "Name" = "eks-prod-example"
      })
  )

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.iam_prod_eks_service_policy_eks_cluster,
    aws_iam_role_policy_attachment.iam_prod_eks_service_policy_eks_vpc_resource_controller,
  ]
}

resource "aws_eks_node_group" "eks-node-group-prod-example" {
  cluster_name    = aws_eks_cluster.eks-prod-example.name
  node_group_name = "eks-node-group-prod-example"
  node_role_arn   = aws_iam_role.iam_prod_eks_service_role.arn
  subnet_ids      = [aws_subnet.subnet-prod-tire-2-app-1a.id, aws_subnet.subnet-prod-tire-2-app-1b.id]
  instance_types  = var.eks_node_group_ec2_instance_types

  scaling_config {
    desired_size = var.eks_node_group_scaling_config_desired_size
    max_size     = var.eks_node_group_scaling_config_max_size
    min_size     = var.eks_node_group_scaling_config_min_size
  }

  update_config {
    max_unavailable = 1
  }

  # Optional: Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.iam_prod_eks_service_policy_eks_worker_node,
    aws_iam_role_policy_attachment.iam_prod_eks_service_policy_eks_cni,
    aws_iam_role_policy_attachment.iam_prod_eks_service_policy_eks_ec2_container_registery_ro,
  ]

  tags = merge(
      local.common_tags,
      tomap({
          "Name" = "eks-node-group-prod-example"
      })
  )
}
