variable "vpc_id" {
  default = ""
}
variable "availability_zone" {
  default = ""
}
variable "cidr_block" {
  default = ""
}
variable "tags" {
  default = {}
}

variable "subnets" {
  type    = any
  default = {}
}
