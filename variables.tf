variable "aws_region" {
	default = "ap-northeast-3"
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
