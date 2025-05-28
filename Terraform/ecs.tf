resource "aws_ecs_cluster" "arm_ecs_cluster" {

  name = "arm_ecs_cluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_ecs_task_definition" "database_task" {
  container_definitions = jsonencode(
    [
      {
        command    = []
        cpu        = 256
        entryPoint = []
        environment = [
          {
            name  = "MYSQL_DATABASE"
            value = "wt24"
          },
          {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "password"
          },
        ]
        essential = true
      
        image       = "mysql:5.7"
        memory      = 512
        mountPoints = []
        name        = "database"
        portMappings = [
          {
            containerPort = 3306
            hostPort      = 3306
            protocol      = "tcp"
          },
        ]
        volumesFrom = []
      },
    ]
  )
  execution_role_arn = data.aws_iam_role.lab_role.arn
  family             = "database-task"
  requires_compatibilities = [
    "EC2",
  ]
  task_role_arn = data.aws_iam_role.lab_role.arn

  placement_constraints {
    expression = "attribute:ecs.subnet-id in [${aws_subnet.arm_subnet_private.id}]"
    type       = "memberOf"
  }
}

resource "aws_ecs_service" "database_service" {
  name            = "database-service"
  cluster         = aws_ecs_cluster.arm_ecs_cluster.id
  task_definition = aws_ecs_task_definition.database_task.arn
  desired_count   = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  launch_type = "EC2"
}
