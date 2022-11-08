resource "aws_iam_role" "iam_prod_eks_service_role" {
  name = "ProdEKSServiceRole"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com.cn"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  
  tags = merge(
      local.common_tags,
      tomap({
          "Name" = "ProdEKSServiceRole"
      })
  )
}

resource "aws_iam_role" "iam_prod_eks_service_oidc_role" {
  name = "ProdPolicyForEKSOIDCServiceRole"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws-cn:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(aws_eks_cluster.eks-prod-example.identity.0.oidc.0.issuer, "https://","")}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${replace(aws_eks_cluster.eks-prod-example.identity.0.oidc.0.issuer, "https://","")}:aud": "sts.amazonaws.com",
          "${replace(aws_eks_cluster.eks-prod-example.identity.0.oidc.0.issuer, "https://","")}:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }
  ]
}
POLICY

  tags = merge(
      local.common_tags,
      tomap({
          "Name" = "ProdPolicyForEKSOIDCServiceRole"
      })
  )
}

resource "aws_iam_openid_connect_provider" "eks_oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc-certificate.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.eks-prod-example.identity.0.oidc.0.issuer

  tags = merge(
      local.common_tags,
      tomap({
          "Name" = "eks_oidc_provider"
      })
  )
}

resource "aws_iam_policy" "iam_prod_eks_service_policy_lb" {
    name = "AWSLoadBalancerControllerIAMPolicy"
    # role = aws_iam_role.iam_prod_eks_service_role.id

    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateServiceLinkedRole"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "iam:AWSServiceName": "elasticloadbalancing.amazonaws.com"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeAccountAttributes",
        "ec2:DescribeAddresses",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeInternetGateways",
        "ec2:DescribeVpcs",
        "ec2:DescribeVpcPeeringConnections",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeInstances",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribeTags",
        "ec2:GetCoipPoolUsage",
        "ec2:DescribeCoipPools",
        "elasticloadbalancing:DescribeLoadBalancers",
        "elasticloadbalancing:DescribeLoadBalancerAttributes",
        "elasticloadbalancing:DescribeListeners",
        "elasticloadbalancing:DescribeListenerCertificates",
        "elasticloadbalancing:DescribeSSLPolicies",
        "elasticloadbalancing:DescribeRules",
        "elasticloadbalancing:DescribeTargetGroups",
        "elasticloadbalancing:DescribeTargetGroupAttributes",
        "elasticloadbalancing:DescribeTargetHealth",
        "elasticloadbalancing:DescribeTags"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cognito-idp:DescribeUserPoolClient",
        "acm:ListCertificates",
        "acm:DescribeCertificate",
        "iam:ListServerCertificates",
        "iam:GetServerCertificate",
        "waf-regional:GetWebACL",
        "waf-regional:GetWebACLForResource",
        "waf-regional:AssociateWebACL",
        "waf-regional:DisassociateWebACL",
        "wafv2:GetWebACL",
        "wafv2:GetWebACLForResource",
        "wafv2:AssociateWebACL",
        "wafv2:DisassociateWebACL",
        "shield:GetSubscriptionState",
        "shield:DescribeProtection",
        "shield:CreateProtection",
        "shield:DeleteProtection"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupIngress"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateSecurityGroup"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateTags"
      ],
      "Resource": "arn:aws-cn:ec2:*:*:security-group/*",
      "Condition": {
        "StringEquals": {
          "ec2:CreateAction": "CreateSecurityGroup"
        },
        "Null": {
          "aws:RequestTag/elbv2.k8s.aws/cluster": "false"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateTags",
        "ec2:DeleteTags"
      ],
      "Resource": "arn:aws-cn:ec2:*:*:security-group/*",
      "Condition": {
        "Null": {
          "aws:RequestTag/elbv2.k8s.aws/cluster": "true",
          "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:DeleteSecurityGroup"
      ],
      "Resource": "*",
      "Condition": {
        "Null": {
          "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:CreateLoadBalancer",
        "elasticloadbalancing:CreateTargetGroup"
      ],
      "Resource": "*",
      "Condition": {
        "Null": {
          "aws:RequestTag/elbv2.k8s.aws/cluster": "false"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:CreateListener",
        "elasticloadbalancing:DeleteListener",
        "elasticloadbalancing:CreateRule",
        "elasticloadbalancing:DeleteRule"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:AddTags",
        "elasticloadbalancing:RemoveTags"
      ],
      "Resource": [
        "arn:aws-cn:elasticloadbalancing:*:*:targetgroup/*/*",
        "arn:aws-cn:elasticloadbalancing:*:*:loadbalancer/net/*/*",
        "arn:aws-cn:elasticloadbalancing:*:*:loadbalancer/app/*/*"
      ],
      "Condition": {
        "Null": {
          "aws:RequestTag/elbv2.k8s.aws/cluster": "true",
          "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:AddTags",
        "elasticloadbalancing:RemoveTags"
      ],
      "Resource": [
        "arn:aws-cn:elasticloadbalancing:*:*:listener/net/*/*/*",
        "arn:aws-cn:elasticloadbalancing:*:*:listener/app/*/*/*",
        "arn:aws-cn:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
        "arn:aws-cn:elasticloadbalancing:*:*:listener-rule/app/*/*/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:ModifyLoadBalancerAttributes",
        "elasticloadbalancing:SetIpAddressType",
        "elasticloadbalancing:SetSecurityGroups",
        "elasticloadbalancing:SetSubnets",
        "elasticloadbalancing:DeleteLoadBalancer",
        "elasticloadbalancing:ModifyTargetGroup",
        "elasticloadbalancing:ModifyTargetGroupAttributes",
        "elasticloadbalancing:DeleteTargetGroup"
      ],
      "Resource": "*",
      "Condition": {
        "Null": {
          "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:RegisterTargets",
        "elasticloadbalancing:DeregisterTargets"
      ],
      "Resource": "arn:aws-cn:elasticloadbalancing:*:*:targetgroup/*/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:SetWebAcl",
        "elasticloadbalancing:ModifyListener",
        "elasticloadbalancing:AddListenerCertificates",
        "elasticloadbalancing:RemoveListenerCertificates",
        "elasticloadbalancing:ModifyRule"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "iam_prod_eks_service_policy_oidc" {
  policy_arn = aws_iam_policy.iam_prod_eks_service_policy_lb.arn
  role       = aws_iam_role.iam_prod_eks_service_oidc_role.name
}

resource "aws_iam_role_policy_attachment" "iam_prod_eks_service_policy_eks" {
  policy_arn = aws_iam_policy.iam_prod_eks_service_policy_lb.arn
  role       = aws_iam_role.iam_prod_eks_service_role.name
}

resource "aws_iam_role_policy_attachment" "iam_prod_eks_service_policy_eks_cluster" {
  policy_arn = "arn:aws-cn:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.iam_prod_eks_service_role.name
}

resource "aws_iam_role_policy_attachment" "iam_prod_eks_service_policy_eks_vpc_resource_controller" {
  policy_arn = "arn:aws-cn:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.iam_prod_eks_service_role.name
}

resource "aws_iam_role_policy_attachment" "iam_prod_eks_service_policy_eks_worker_node" {
  policy_arn = "arn:aws-cn:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.iam_prod_eks_service_role.name
}

resource "aws_iam_role_policy_attachment" "iam_prod_eks_service_policy_eks_cni" {
  policy_arn = "arn:aws-cn:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.iam_prod_eks_service_role.name
}

resource "aws_iam_role_policy_attachment" "iam_prod_eks_service_policy_eks_ec2_container_registery_ro" {
  policy_arn = "arn:aws-cn:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.iam_prod_eks_service_role.name
}
