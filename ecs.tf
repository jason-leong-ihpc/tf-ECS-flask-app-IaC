module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 5.9.0"

  cluster_name = "${local.name_prefix}-ecs"
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }

  services = {
    s3-ecs-service = { #task definition and service name -> #Change
      cpu    = 512
      memory = 1024
      container_definitions = {
        s3-container = { #container name -> Change
          essential = true
          image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${local.name_prefix}-s3:latest"
          port_mappings = [
            {
              containerPort = 5001
              protocol      = "tcp"
            }
          ]
      environment = [
        {
          name  = "AWS_REGION"
          value = "${var.aws_region}"
        },
        {
          name  = "BUCKET_NAME"
          value = "${aws_s3_bucket.static_bucket.bucket}"
        }
      ]          
        }
      }
      assign_public_ip                   = true
      deployment_minimum_healthy_percent = 100
      subnet_ids                         = flatten(data.aws_subnets.public.ids)         #List of subnet IDs to use for your tasks
      security_group_ids                 = [module.security_group_s3.security_group_id] #Create a SG resource and pass it here
      create_task_instance_role          = false
      tasks_iam_role_arn                 = aws_iam_role.ecs_role.arn #Change
    }
    sqs-ecs-service = { #task definition and service name -> #Change
      cpu    = 512
      memory = 1024
      container_definitions = {
        sqs-container = { #container name -> Change
          essential = true
          image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${local.name_prefix}-sqs:latest"
          port_mappings = [
            {
              containerPort = 5002
              protocol      = "tcp"
            }
          ]
        }
      }
      assign_public_ip                   = true
      deployment_minimum_healthy_percent = 100
      subnet_ids                         = flatten(data.aws_subnets.public.ids)          #List of subnet IDs to use for your tasks
      security_group_ids                 = [module.security_group_sqs.security_group_id] #Create a SG resource and pass it here
    }

  }
}

module "security_group_s3" {

  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1.0"

  name        = "${local.name_prefix}-ecs-s3-sg"
  description = "S3 app security group"
  vpc_id      = data.aws_vpc.default.id

  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 5001
      to_port     = 5001
      protocol    = "tcp"
      description = "S3 app security group rule"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "security_group_sqs" {

  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1.0"

  name        = "${local.name_prefix}-ecs-sqs-sg"
  description = "SQS app security group"
  vpc_id      = data.aws_vpc.default.id

  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 5002
      to_port     = 5002
      protocol    = "tcp"
      description = "SQS app security group rule"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}