## Environment and VPC
variable "region_name" {
    default = "cn-north-1"
}

variable "availability_zone_names" {
    default = ["cn-north-1a","cn-north-1b"]
}

locals {
    common_tags = tomap({
        "Environment" = "Production",
        "Owner" = "Jasecharloote",
        "ResourceManager" = "Terraform",
        "Project" = "Example"
    })
}

## EKS
variable "eks_node_group_scaling_config_max_size" { default = 3 }
variable "eks_node_group_scaling_config_min_size" { default = 1 }
variable "eks_node_group_scaling_config_desired_size" { default = 2 }
variable "eks_node_group_ec2_instance_types" { default = ["m5.xlarge"] }  # default ["t3.medium"]