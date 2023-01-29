#######
# EC2 Instance / VM

resource "aws_security_group" "beacon_compose_instance_sg" {
  name        = "${local.stack_name_dash}-instance-sg"
  description = "Allow inbound only from Beacon ALB"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    security_groups = [
      aws_security_group.beacon_compose_alb_sg.id,
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "beacon_compose_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.2.1"

  name                        = "JavaBeaconInstance"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  hibernation                 = var.hibernation
  associate_public_ip_address = true
  create_iam_instance_profile = true
  iam_role_description        = "IAM Role for Java Beacon EC2 Instance"
  iam_role_policies           = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"  # FIXME this may be too high for PROD env
  }

  vpc_security_group_ids = [aws_security_group.beacon_compose_instance_sg.id]

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = var.root_disk_size
    },
  ]

  ebs_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = var.data_disk_size
      device_name = "/dev/sdf"
    }
  ]

  tags = {
    Description = "Java Beacon Instance created by Beacon Compose Stack"
  }
}
