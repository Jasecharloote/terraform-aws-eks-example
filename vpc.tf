# Create a VPC
resource "aws_vpc" "vpc-prod-example" {
  cidr_block              = "10.0.0.0/16"
  instance_tenancy        = "default"
  enable_dns_hostnames    = true
  enable_dns_support      = true

  tags = merge(
      local.common_tags,
      tomap({
          "Name" = "vpc-prod-example"
      })
  )
}