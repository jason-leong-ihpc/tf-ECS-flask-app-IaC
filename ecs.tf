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
        }
      }
      assign_public_ip                   = true
      deployment_minimum_healthy_percent = 100
      subnet_ids                         = flatten(data.aws_subnets.public.ids)         #List of subnet IDs to use for your tasks
      security_group_ids                 = [module.security_group_s3.security_group_id] #Create a SG resource and pass it here
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

  name        = "${local.name_prefix}-ecs-sg"
  description = "ECS security group"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-5001-tcp"]
  egress_rules        = ["all-all"]
}

module "security_group_sqs" {

  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1.0"

  name        = "${local.name_prefix}-ecs-sg"
  description = "ECS security group"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-5002-tcp"]
  egress_rules        = ["all-all"]
}