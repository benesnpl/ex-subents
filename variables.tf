variable "aws_region" {
	default = "ap-northeast-3"
}

variable "tgw-sub1" {
	default = "subnet-0ba95bcefb564a33a"
}

variable "tgw-sub2" {
	default = "subnet-009eaf0ed0f70b5ff"
}

variable "prv-sub1" {
	default = "subnet-0eb8e8ca0941836da"
}

variable "prv-sub2" {
	default = "subnet-06616e4504ae42805"
}

variable "mng-sub1" {
	default = "subnet-025de6e9104e64776"
}


variable "mng-sub2" {
	default = "subnet-0199bfb0f358637f8"
}


variable "gwlb-sub1" {
	default = "subnet-063c160ffc65dbb1b"
}

variable "gwlb-sub2" {
	default = "subnet-0005618a3ca75459f"
}


variable "gwlbe-sub1" {
	default = "subnet-0991f9901f298ccd3"
}

variable "gwlbe-sub2" {
	default = "subnet-02bcd0492c4772591"
}


variable "pub-sub1" {
	default = "subnet-0c8733bef4b4d1945"
}

variable "pub-sub2" {
	default = "subnet-0d4c2898683fc4961"
}


variable "vpc_cidr" {
	default = "vpc-04bbc382a70c6adf6"
}

variable "coid" {
	default = "PROT"
}

variable "sub_tgw" {
  type = list(string)
  default = ["subnet-0ba95bcefb564a33a","subnet-009eaf0ed0f70b5ff"]
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
	default = "207.223.34.132"
}

variable "fl_external" {
	default = "62.103.97.241"
}

variable "azs" {
	type = list
	default = ["ap-northeast-3a","ap-northeast-3b"]
}

variable "instance_type" {
	default = "m5.2xlarge"
}

variable "ssh_key_name" {
	default = "firewall"
}

variable "mgm_ip_address1" {
	default = "192.168.0.10"
}

variable "mgm_ip_address2" {
	default = "192.168.1.10"
}

variable "public_eni_1" {
	default = "192.168.0.132"
}

variable "public_eni_2" {
	default = "192.168.1.132"
}

variable "private_eni_1" {
	default = "192.168.0.20"
}

variable "private_eni_2" {
	default = "192.168.1.20"
}
