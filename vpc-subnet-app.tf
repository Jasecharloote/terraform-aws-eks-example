resource "aws_subnet" "subnet-prod-tire-2-app-1a" {
    vpc_id                  = aws_vpc.vpc-prod-example.id
    cidr_block              = "10.0.18.0/24"
    map_public_ip_on_launch = "false"
    availability_zone       = var.availability_zone_names[0]

    tags = merge(
        local.common_tags,
        tomap({
            "Name" = "subnet-prod-tire-2-app-1a",
            "kubernetes.io/role/internal-elb" = 1,
            "kubernetes.io/cluster/eks-prod-example" = "shared"
        })
    )
}

resource "aws_subnet" "subnet-prod-tire-2-app-1b" {
    vpc_id                  = aws_vpc.vpc-prod-example.id
    cidr_block              = "10.0.19.0/24"
    map_public_ip_on_launch = "false"
    availability_zone       = var.availability_zone_names[1]

    tags = merge(
        local.common_tags,
        tomap({
            "Name" = "subnet-prod-tire-2-app-1b",
            "kubernetes.io/role/internal-elb" = 1,
            "kubernetes.io/cluster/eks-prod-example" = "shared"
        })
    )
}
