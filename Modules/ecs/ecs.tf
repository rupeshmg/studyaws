#ECS Cluster
resource "aws_ecs_cluster" "DG-Cluster" {
  name = "DG-Cluster"
}

#ECS service
resource "aws_ecs_service" "dg-service" {
  name            = "dg-ecs-service"
  cluster         = "${aws_ecs_cluster.DG-Cluster.id}"
  task_definition = "${aws_ecs_task_definition.search_service_task.id}"
  desired_count   = 2

  load_balancer {
    target_group_arn = "${aws_alb_target_group.ecs-target-group.arn}"
    container_port   = 80
    container_name   = "wordpress"
  }
}

//"valueFrom": "arn:aws:ssm:us-east-1:${local.account_id}:parameter/dgneo-${var.env_name}-documentdbpassword"

//https://github.com/spring-cloud/spring-cloud-sleuth/issues/1075

# ECS Task Definition
resource "aws_ecs_task_definition" "search_service_task" {
  family                = "dg-ecs-service"
  container_definitions = "${file("Modules/ecs/service.json")}"
}

#Security group for ec2 instance

resource "aws_security_group" "ecs_sg" {
  name        = "dg_ec2_instance"
  vpc_id      = "${var.aws_vpc_default_id}"
  description = "Security group for dg"

  #Allow http and https access to ec2 instances
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  #Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.anywhere}"]
  }
}

output "aws_sg_id" {
  value = "${aws_security_group.ecs_sg.id}"
}

#ALB load balancer
resource "aws_alb" "ecs-load-balancer" {
  name = "ecs-load-balancer"

  security_groups = ["${aws_security_group.ecs_sg.id}"]
  subnets         = ["${var.aws_subnet_dgsubnet1_id}", "${var.aws_subnet_dgsubnet2_id}"]

  tags {
    Name = "ecs-load-balancer"
  }
}

#ALB Load balancer target group
resource "aws_alb_target_group" "ecs-target-group" {
  name     = "ecs-target-group"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "${var.aws_vpc_default_id}"

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }

  tags {
    Name = "ecs-target-group"
  }
}

#ALB Listener
resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = "${aws_alb.ecs-load-balancer.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.ecs-target-group.arn}"
    type             = "forward"
  }
}
