resource "aws_launch_configuration" "ecs-launch-configuration" {
  name          = "ecs-launch-configuration"
  image_id      = "ami-04393f622fe20a8dd"
  instance_type = "t2.xlarge"

  // iam_instance_profile = "${aws_iam_instance_profile.ecs-instance-profile.id}"

  root_block_device {
    volume_type           = "standard"
    volume_size           = 100
    delete_on_termination = true
  }
  lifecycle {
    create_before_destroy = true
  }
  security_groups             = ["${var.aws_sg_id}"]
  associate_public_ip_address = "true"

  //key_name                    = "${var.ecs_key_pair_name}"
  /*user_data = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=${var.ecs_cluster} >> /etc/ecs/ecs.config
                                  EOF*/
}

#Autoscaling group 
resource "aws_autoscaling_group" "ecs-autoscaling-group" {
  name = "ecs-autoscaling-group"

  max_size = "4"
  min_size = "2"

  //desired_capacity     = "${var.desired_capacity}"
  vpc_zone_identifier = ["${var.aws_subnet_dgsubnet1_id}", "${var.aws_subnet_dgsubnet1_id}"]

  launch_configuration = "${aws_launch_configuration.ecs-launch-configuration.name}"
  health_check_type    = "ELB"
}
