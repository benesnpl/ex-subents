provider "aws" {
  region = var.aws_region
}

resource "aws_ec2_transit_gateway" "main_tgw" {
  description = "TGW"
  auto_accept_shared_attachments = "enable"
  tags = {
   Name = join("", [var.coid, "-TGW"])
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-main" {
  depends_on = [aws_ec2_transit_gateway.main_tgw]
  subnet_ids         = ["subnet-009eaf0ed0f70b5ff","subnet-0ba95bcefb564a33a"]
  transit_gateway_id = aws_ec2_transit_gateway.main_tgw.id
  vpc_id             = var.vpc_cidr
  appliance_mode_support = "enable"
  tags = {
   Name = join("", [var.coid, "-SecVPC"])
  }
}
