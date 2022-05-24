variable "aws_region" {
	default = null
}

variable "tgw-sub1" {
	default = null
}

variable "tgw-sub2" {
	default = null
}

variable "prv-sub1" {
	default = null
}

variable "prv-sub2" {
	default = null
}

variable "mng-sub1" {
	default = null
}


variable "mng-sub2" {
	default = null
}


variable "gwlb-sub1" {
	default = null
}

variable "gwlb-sub2" {
	default = null
}


variable "gwlbe-sub1" {
	default = null
}

variable "gwlbe-sub2" {
	default = null
}


variable "pub-sub1" {
	default = null
}

variable "pub-sub2" {
	default = null
}


variable "vpc_cidr" {
	default = null
}

variable "coid" {
	default = null
}



variable "rules_inbound_public_sg" {
  default = [
    {
      port = 0
      proto = "-1"
      cidr_block = ["0.0.0.0/0"]
    }
    ]
}

variable "rules_outbound_public_sg" {
  default = [
    {
      port = 0
      proto = "-1"
      cidr_block = ["0.0.0.0/0"]
    }
    ]
}

variable "rules_inbound_private_sg" {
  default = [
    {
      port = 0
      proto = "-1"
      cidr_block = ["10.0.0.0/8","192.168.0.0/16","172.16.0.0/12","100.70.0.0/15"]
    }
    ]
}

variable "rules_outbound_private_sg" {
  default = [
    {
      port = 0
      proto = "-1"
      cidr_block = ["0.0.0.0/0"]
    }
    ]
}

variable "rules_inbound_mgmt_sg" {
  default = [
  
    {
      port = 22
      proto = "tcp"
      cidr_block = ["10.159.94.0/23"]
    },
	
	{
      port = 443
      proto = "tcp"
      cidr_block = ["10.159.94.0/23"]
    },
	
	
	{
      port = 161
      proto = "udp"
      cidr_block = ["10.159.94.0/23"]
    },
	
	{
      port = 8
      proto = "icmp"
      cidr_block = ["10.159.94.0/23"]
    },
	
	{
      port = 22
      proto = "tcp"
      cidr_block = ["100.70.0.0/15"]
    },
	
	{
      port = 443
      proto = "tcp"
      cidr_block = ["100.70.0.0/15"]
    },
	
	
	{
      port = 161
      proto = "udp"
      cidr_block = ["100.70.0.0/15"]
    },
	
	{
      port = 8
      proto = "icmp"
      cidr_block = ["100.70.0.0/15"]
    }
	
	
    ]
}

variable "rules_outbound_mgmt_sg" {
  default = [
    {
      port = 0
      proto = "-1"
      cidr_block = ["0.0.0.0/0"]
    }
    ]
}

variable "il_external" {
	default = null
}

variable "fl_external" {
	default = null
}

variable "azs" {
	type = list
	default = null
}

variable "instance_type" {
	default = null
}

variable "ssh_key_name" {
	default = null
}

variable "mgm_ip_address1" {
	default = null
}

variable "mgm_ip_address2" {
	default = null
}

variable "public_eni_1" {
	default = null
}

variable "public_eni_2" {
	default = null
}

variable "private_eni_1" {
	default = null
}

variable "private_eni_2" {
	default = null
}
