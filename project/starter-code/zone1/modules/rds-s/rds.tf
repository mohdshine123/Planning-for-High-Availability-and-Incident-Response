variable primary_db_cluster_arn {}

resource "aws_rds_cluster_parameter_group" "cluster_pg" {
  name   = "udacity-pg-s"
  #family = "aurora-postgresql15"
  family ="aurora-mysql5.7"

  parameter {
    name  = "binlog_format"    
    value = "MIXED"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "log_bin_trust_function_creators"
    value = 1
    apply_method = "pending-reboot"
 }
}

resource "aws_db_subnet_group" "udacity_db_subnet_group" {
  name       = "udacity_db_subnet_group"
  subnet_ids = var.private_subnet_ids
}

#resource "aws_db_parameter_group" "education" {
  #name   = "education"
 # family = "es15"
  #family ="aurora-mysql5.7"

  #parameter {
   # name  = "log_connections"
   # value = "1"
 # }
}

resource "aws_rds_cluster" "udacity_cluster-s" {
  cluster_identifier       = "udacity-db-cluster-s"
  #availability_zones       = ["us-west-1b", "us-west-1c"]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.cluster_pg.name
  #database_name            = "udacityc2"
  #master_username          = "udacity"
  #master_password          = "MyUdacityPassword"
  vpc_security_group_ids   = [aws_security_group.db_sg2.id] 
  db_subnet_group_name     = aws_db_subnet_group.udacity_db_subnet_group.name
  #vpc_security_group_ids = var.vpc_security_group_ids
  #db_subnet_group_name   = var.db_subnet_group_name
  #db_cluster_parameter_group_name   = var.db_cluster_parameter_group_name
  engine_mode              = "provisioned"
  engine                 = "aurora-mysql"
  engine_version         = "5.7.mysql_aurora.2.07.9"  
  #engine_version           = "5.6.mysql_aurora.1.19.1" 
  #engine                 = "aurora-postgresql"
  #engine_version         = "15.3"
  #allocated_storage      = 20
  skip_final_snapshot      = true
  storage_encrypted        = false
  #backup_retention_period  = 5
  replication_source_identifier   = var.primary_db_cluster_arn
  source_region            = "us-east-2"
  depends_on = [aws_rds_cluster_parameter_group.cluster_pg]
}


#output "db_cluster_arn" {
  #description = "The ARN of the RDS Cluster"
  #value = aws_rds_cluster.udacity_cluster.arn
#}


resource "aws_rds_cluster_instance" "udacity_instance-s" {
  count                = 2
  identifier           = "udacity-db-instance-${count.index}-s"
  cluster_identifier   = aws_rds_cluster.udacity_cluster.id
  engine                 = "aurora-mysql"
  instance_class       = "db.t3.medium"
  #allocated_storage      = 20
  availability_zone      =data.aws_availability_zones.available.names[count.index]
  db_subnet_group_name = aws_db_subnet_group.udacity_db_subnet_group.name
}

resource "aws_security_group" "db_sg_2" {
  name   = "udacity-db-sg"
  vpc_id =  var.vpc_id

  ingress {
    from_port   = 3306
    protocol    = "TCP"
    to_port     = 3306
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    protocol    = "TCP"
    to_port     = 3306
    cidr_blocks = ["0.0.0.0/0"]
  }
}
