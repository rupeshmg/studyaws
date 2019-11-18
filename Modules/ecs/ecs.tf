#ECS Cluster
resource "aws_ecs_cluster" "DG-Cluster" {
  name = "DG-Cluster"
}

#ECS task definition

#ECS service
resource "aws_ecs_service" "dg-service" {
  name            = "dg-ecs-service"
  iam_role        = "${aws_iam_role.ecs-service-role.name}"
  cluster         = "${aws_ecs_cluster.DG-Cluster.id}"
  task_definition = "${aws_ecs_task_definition.wordpress.family}:${max("${aws_ecs_task_definition.wordpress.revision}", "${data.aws_ecs_task_definition.wordpress.revision}")}"
  desired_count   = 2
}
