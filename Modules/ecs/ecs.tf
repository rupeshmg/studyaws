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
}

//"valueFrom": "arn:aws:ssm:us-east-1:${local.account_id}:parameter/dgneo-${var.env_name}-documentdbpassword"

//https://github.com/spring-cloud/spring-cloud-sleuth/issues/1075

# ECS Task Definition
resource "aws_ecs_task_definition" "search_service_task" {
  family                = "dg-ecs-service"
  container_definitions = "${file("Modules/ecs/service.json")}"
}

#ALB load balancer
#resource " aws_alb_listener" "search_service_alb" {}

