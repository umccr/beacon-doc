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
  default = "t3.large"  # 2 vCPU, 8GB MEM
}

variable "root_disk_size" {
  default = 20  # in GB
}

variable "data_disk_size" {
  default = 300  # in GB
}
