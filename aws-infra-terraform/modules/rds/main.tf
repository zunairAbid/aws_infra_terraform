resource "aws_db_subnet_group" "subnet_group" {
  name        = "${var.global_variables.project}-${var.global_variables.app}-${terraform.workspace}-subnet-group"
  description = "Aurora cluster for ${terraform.workspace} environment."
  subnet_ids  = var.subnets

  tags = {
    Name = "${var.global_variables.project}-${var.global_variables.app}-${terraform.workspace}-subnet-group"
  }
}

resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier        = "${var.global_variables.project}-${var.global_variables.app}-${terraform.workspace}-aurora-db"
  engine                    = var.rds.engine
  engine_version            = var.rds.engine_version
  database_name             = var.rds.database_name
  master_username           = var.rds.master_username
  master_password           = var.rds.master_password
  final_snapshot_identifier = var.rds.final_snapshot_identifier
  skip_final_snapshot       = var.rds.skip_final_snapshot
  db_subnet_group_name      = aws_db_subnet_group.subnet_group.name
  vpc_security_group_ids    = [var.rds_sg]

  tags = {
    Name = "${var.global_variables.project}-${var.global_variables.app}-${terraform.workspace}-rds-cluster"
  }
}
resource "aws_rds_cluster_instance" "cluster_instances" {
  count                = var.rds.count
  identifier           = "${var.global_variables.project}-${var.global_variables.app}-${terraform.workspace}-aurora-cluster-instance"
  cluster_identifier   = aws_rds_cluster.rds_cluster.id
  instance_class       = var.rds.instance_class
  engine               = aws_rds_cluster.rds_cluster.engine
  engine_version       = aws_rds_cluster.rds_cluster.engine_version
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name
  publicly_accessible  = var.rds.publicly_accessible
  tags = {
    Name = "${var.global_variables.project}-${var.global_variables.app}-${terraform.workspace}-aurora-cluster-instance"
  }
}