variable "aws_region" {
  default = "ap-southeast-2"
}

variable "base_domain" {
  default = "demo.umccr.org"
}

variable "app_domain" {
  default = "faro.demo.umccr.org"
}

variable "instance_type" {
  default = "r6i.large"  # 2 vCPU, 16GB MEM
}

variable "root_disk_size" {
  default = 20  # in GB
}

variable "data_disk_size" {
  default = 500  # in GB
}

variable "hibernation" {
  default = false
}
