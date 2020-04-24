provider "aws" {
    region = "us-east-1"
}

resource "aws_launch_configuration" "as_conf" {
  name_prefix   = "pingpong"
  image_id      = "ami-0676dde177ea05884"
  instance_type = "t2.micro"
  user_data = "#!/bin/bash \n systemctl start cloudmap"


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bar" {
  launch_configuration = aws_launch_configuration.as_conf.name
  availability_zones = ["us-east-1a"]
  desired_capacity   = 3
  max_size           = 3
  min_size           = 3
}
