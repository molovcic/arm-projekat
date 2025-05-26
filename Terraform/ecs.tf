resource "aws_ecs_cluster" "arm_ecs_cluster" {

  name = "arm_ecs_cluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_ecs_task_definition" "frontend_task" {
  container_definitions = jsonencode(
    [
      {
        command    = []
        cpu        = 256
        entryPoint = []
        environment = [
          {
            name  = "MYSQL_DB"
            value = aws_instance.arm_server_private.private_dns
          },
        ]
        essential   = true
        image       = "kibrovic/frontend-task"
        memory      = 512
        mountPoints = []
        name        = "frontend-task"
        portMappings = [
          {
            containerPort = 8080
            hostPort      = 80
            protocol      = "tcp"
          },
        ]
        volumesFrom = []
      },
    ]
  )
  execution_role_arn = data.aws_iam_role.lab_role.arn
  family             = "frontend-task"
  requires_compatibilities = [
    "EC2",
  ]
  task_role_arn = data.aws_iam_role.lab_role.arn

  placement_constraints {
    expression = "attribute:ecs.subnet-id in [${aws_subnet.arm_subnet_public.id}]"
    type       = "memberOf"
  }
}

resource "aws_ecs_service" "frontend_service" {
  cluster                            = aws_ecs_cluster.arm_ecs_cluster.id
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  desired_count                      = 1
  name                               = "frontend-service"
  task_definition                    = aws_ecs_task_definition.frontend_task.arn
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
        healthCheck = {
          command = [
            "mysqladmin ping -h localhost",
          ]
          interval = 30
          retries  = 10
          timeout  = 20
        }
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
  cluster                            = aws_ecs_cluster.arm_ecs_cluster.id
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  desired_count                      = 1
  name                               = "database-service"
  task_definition                    = aws_ecs_task_definition.database_task.arn
}
