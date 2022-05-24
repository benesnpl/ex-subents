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

resource "aws_internet_gateway" "main_igw" {
  depends_on = [aws_ec2_transit_gateway.main_tgw,aws_internet_gateway.main_igw]
  vpc_id = var.vpc_cidr
  tags = {
    Name = join("", [var.coid, "-IGW"])
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_cidr
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
  
  
  tags = {
    Name = ("Public-rt")
  }
}

resource "aws_route_table_association" "public" {
  depends_on = [aws_route_table.public_rt]
  subnet_id      = "subnet-0c8733bef4b4d1945"
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public2" {
  depends_on = [aws_route_table.public_rt]
  subnet_id      = "subnet-0d4c2898683fc4961"
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_lb" "gwlb" {
  name                             = "GWLB-Private"
  load_balancer_type               = "gateway"
  enable_cross_zone_load_balancing = true
  subnets                          = ["subnet-063c160ffc65dbb1b","subnet-0005618a3ca75459f"]
  
}

resource "aws_vpc_endpoint_service" "vpc_end_serv" {
  depends_on = [aws_lb.gwlb]
  acceptance_required        = false
  gateway_load_balancer_arns = [aws_lb.gwlb.arn]
  tags = {
    Name = ("VPCE-GWLB")
  }
}

  resource "aws_lb_target_group" "tgt_group" {
  name                 = "GWLB-Group"
  vpc_id               = var.vpc_cidr
  target_type          = "ip"
  protocol             = "GENEVE"
  port                 = "6081"

  health_check {
    enabled             = true
    interval            = 5
    path                = "/php/login.php"
    port                = 443
    protocol            = "HTTPS"
  }
}
  resource "aws_lb_target_group_attachment" "register-tgp1" {
  depends_on       = [aws_lb_target_group.tgt_group]
  target_group_arn = aws_lb_target_group.tgt_group.arn
  target_id        = "192.168.0.20"
  port             = 6081
}

  resource "aws_lb_target_group_attachment" "register-tgp2" {
  depends_on       = [aws_lb_target_group.tgt_group]
  target_group_arn = aws_lb_target_group.tgt_group.arn
  target_id        = "192.168.1.20"
  port             = 6081
}

 resource "aws_lb_listener" "listener" {
  depends_on       = [aws_lb_target_group_attachment.register-tgp2,aws_lb_target_group_attachment.register-tgp2]
  load_balancer_arn = aws_lb.gwlb.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tgt_group.arn
  }
}

resource "aws_vpc_endpoint" "az1" {
  service_name      = aws_vpc_endpoint_service.vpc_end_serv.service_name
  subnet_ids        = ["subnet-0991f9901f298ccd3"]
  vpc_endpoint_type = aws_vpc_endpoint_service.vpc_end_serv.service_type
  vpc_id            = var.vpc_cidr
  tags = {
    Name = ("Security-AZ1")
  }
}

resource "aws_vpc_endpoint" "az2" {
  service_name      = aws_vpc_endpoint_service.vpc_end_serv.service_name
  subnet_ids        = ["subnet-02bcd0492c4772591"]
  vpc_endpoint_type = aws_vpc_endpoint_service.vpc_end_serv.service_type
  vpc_id            = var.vpc_cidr
  tags = {
    Name = ("Security-AZ2")
  }
}

resource "aws_route_table" "tgw1_rt" {
  depends_on = [aws_vpc_endpoint.az1]
  vpc_id = var.vpc_cidr
  
  route {
    cidr_block = "0.0.0.0/0"
    vpc_endpoint_id = aws_vpc_endpoint.az1.id
  }
  
  
  tags = {
    Name = ("TGW-AZ1-rt")
  }
}

resource "aws_route_table_association" "tgw1" {
  depends_on = [aws_route_table.tgw1_rt]
  subnet_id      = "subnet-0ba95bcefb564a33a"
  route_table_id = aws_route_table.tgw1_rt.id
}


resource "aws_route_table" "tgw2_rt" {
  depends_on = [aws_vpc_endpoint.az2]
  vpc_id = var.vpc_cidr
  
  route {
    cidr_block = "0.0.0.0/0"
    vpc_endpoint_id = aws_vpc_endpoint.az2.id
  }
  
  
  tags = {
    Name = ("TGW-AZ2-rt")
  }
}

resource "aws_route_table_association" "tgw2" {
  depends_on = [aws_route_table.tgw2_rt]
  subnet_id      = "subnet-009eaf0ed0f70b5ff"
  route_table_id = aws_route_table.tgw2_rt.id
}

resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "public SG"
  vpc_id      = var.vpc_cidr

  dynamic "ingress" {
    for_each = var.rules_inbound_public_sg
    content {
      from_port = ingress.value["port"]
      to_port = ingress.value["port"]
      protocol = ingress.value["proto"]
      cidr_blocks = ingress.value["cidr_block"]
    }
  }
  dynamic "egress" {
    for_each = var.rules_outbound_public_sg
    content {
      from_port = egress.value["port"]
      to_port = egress.value["port"]
      protocol = egress.value["proto"]
      cidr_blocks = egress.value["cidr_block"]
    }
  }
  tags = {
    Name = join("", [var.coid, "-Public-sg"])
  }
}

 resource "aws_security_group" "private_sg" {
  name        = "private_sg"
  description = "Private SG"
  vpc_id      = var.vpc_cidr

  dynamic "ingress" {
    for_each = var.rules_inbound_private_sg
    content {
      from_port = ingress.value["port"]
      to_port = ingress.value["port"]
      protocol = ingress.value["proto"]
      cidr_blocks = ingress.value["cidr_block"]
    }
  }
  dynamic "egress" {
    for_each = var.rules_outbound_private_sg
    content {
      from_port = egress.value["port"]
      to_port = egress.value["port"]
      protocol = egress.value["proto"]
      cidr_blocks = egress.value["cidr_block"]
    }
  }
  tags = {
    Name = join("", [var.coid, "-Private-sg"])
  }
} 

  resource "aws_security_group" "MGMT_sg" {
  name        = "MGMT_sg"
  description = "MGMT SG"
  vpc_id      = var.vpc_cidr

  dynamic "ingress" {
    for_each = var.rules_inbound_mgmt_sg
    content {
      from_port = ingress.value["port"]
      to_port = ingress.value["port"]
      protocol = ingress.value["proto"]
      cidr_blocks = ingress.value["cidr_block"]
    }
  }
  dynamic "egress" {
    for_each = var.rules_outbound_mgmt_sg
    content {
      from_port = egress.value["port"]
      to_port = egress.value["port"]
      protocol = egress.value["proto"]
      cidr_blocks = egress.value["cidr_block"]
    }
  }
  tags = {
    Name = join("", [var.coid, "-MGMT-sg"])
  }
}
