# This block provisions document elasr=tic cache cluster on aws 

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "roboshop-${var.ENV}-redis"
  engine               = "redis"
  node_type            = var.REDIS_INSTANCE_NODETYPE
  num_cache_nodes      = var.REDIS_INSTANCE_COUNT
  parameter_group_name = aws_elasticache_parameter_group.redis-pg.name
  subnet_group_name    = aws_elasticache_subnet_group.redis-sg.name
  security_group_ids   = [aws_security_group.allow_redis.id]
  engine_version       = var.REDIS_ENGINE_VERSION
  port                 = var.REDIS_PORT
}

# Creates Parameter Group
resource "aws_elasticache_parameter_group" "redis-pg" {
  name   = "roboshop-${var.ENV}-redis-pg"
  family = "redis${var.REDIS_ENGINE_VERSION}"
}

# Creates Subnet Group 
resource "aws_elasticache_subnet_group" "redis-sg" {
  name       = "roboshop-${var.ENV}-redis-sg"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS
}
