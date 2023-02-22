# This block provisions document elasr=tic cache cluster on aws 

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "roboshop-${var.ENV}-redis"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = aws_elasticache_parameter_group.redis-pg.name
  engine_version       = "6.2"
  port                 = 6379
}

# Creates Parameter Group
resource "aws_elasticache_parameter_group" "redis-pg" {
  name   = "roboshop-${var.ENV}-redis-pg"
  family = "redis6.2"
}

# Creates Subnet Group 
resource "aws_elasticache_subnet_group" "redis-sg" {
  name       = "roboshop-${var.ENV}-redis-sg"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS
}


# resource "aws_docdb_cluster" "docdb" {
#   cluster_identifier      = "roboshop-${var.ENV}-docdb"
#   engine                  = "docdb"
#   master_username         = "admin1"
#   master_password         = "roboshop1"
#   vpc_security_group_ids  = [aws_security_group.allow_mongodb.id]
#   db_subnet_group_name    = aws_docdb_subnet_group.docdb.id
# #   backup_retention_period = 5                        Uncomment only when you need backups
# #   preferred_backup_window = "07:00-09:00"
#   skip_final_snapshot     = false
# }

# # Creates Subnet Group 
# resource "aws_docdb_subnet_group" "docdb" {
#   name       = "roboshop-${var.ENV}-docdb-subnet-grp"
#   subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS

#   tags = {
#     Name = "roboshop-${var.ENV}-docdb-subnet-grp"
#   }
# }

# # Provision the nodes needed for doc-db and add them to the docdb cluster.
# resource "aws_docdb_cluster_instance" "cluster_instances" {
#   count              = 1
#   identifier         = "roboshop-${var.ENV}-docdb-nodes"
#   cluster_identifier = aws_docdb_cluster.docdb.id
#   instance_class     = "db.t3.medium"
# }

# # Our application is not designed to work with Document DB. That's because of the fact that AWS don't let youto create Document DB without Username and password
# # Out cart and catalogue code is not designed to talk to mongodb with credentials.

# # Let's try to understand, how can we connect to connect to doc-db. Based on that we can apply that strategy.