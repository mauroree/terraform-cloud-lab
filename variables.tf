variable "region" {
  description = "Região da AWS"
  type        = string
  default     = "us-east-2"
}

variable "instance_type" {
  description = "Tipo da EC2"
  type        = string
  default     = "t3.micro"
}

variable "instance_name" {
  description = "Nome da EC2"
  type        = string
  default     = "terraform-web-lab"
}

variable "key_name" {
  description = "Nome do Key Pair na AWS"
  type        = string
}

variable "environment" {
  description = "Ambiente de deploy (dev ou prod)"
  type        = string
}

