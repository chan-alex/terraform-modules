// Module specific variables

variable "instance_name" {
  description = "Used to populate the Name tag. This is done in main.tf"
}

variable "key_name" {}
variable "instance_type" {}

variable "subnet_id" {
  description = "The VPC subnet the instance(s) will go in"
}

variable "ami_id" {
  description = "The AMI to use"
}

variable "tags" {
  default = {
    created_by = "terraform"
 }
}

variable "disable_api_termination" {
  default = false
}

variable "delete_on_termination" {
  default = false
}