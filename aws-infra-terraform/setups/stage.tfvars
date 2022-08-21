global_variables = {
  aws-region = "us-east-1"
  project= "onboard"
  app= "app"
}

vpc = {
  vpc-cidr       = "10.0.0.0/16"
  public-subnet  = ["10.0.1.0/24", "10.0.2.0/24"]
  private-subnet = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
}

ec2 = {
  instance_type = "t2.small"
  public_key= "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDully1VZIcVhETz5XW8IBjrfOniubm2cp6gayy6uLnt8O+sktmOGtXUtbbCbXiv9+c1KpdW5p/ScC9pGEPdD/bbFaUjwJCYVcKc3auwMJTmMX4bkBrQQjlu6r4j8eRUOUwmLQbdPgYnpfkMHO3atHpld4RXd0jHBZrrEkZULFdpU8jTtApKf/A7g2lx0hRl81DFrwPckrFGShELU8kJcEsRFOqxFLxH1SaoE3ESuXz+GjjpEGGQxtLX3WTn5O2K9wrAZJ0t7tkI/W5yvOAhh3FY5Fk0Oyw3aRYYkwnxuQyX/mWSKwYwTyIOqbxcp2XY+QLJG0ae1tvNNaFUCg8uNpF rsa-key-20220731"
  associate_public_ip_address = true
}

s3 = {
  acl    = "private"
  bucket_name = "onboard-app-stag-s3data-us-east-1"
}

iam = {
  ssm_parameter_name_prefix = "dev"
  ssm_parameter_region= "us-east-1"
  account_id= "249144947172"
  secret_manager_name_prefix = "stag"
  secret_manager_region= "us-east-1"
}

rds = {
  engine                    = "aurora-mysql"
  engine_version            = "8.0.mysql_aurora.3.02.0"
  master_username           = "stagauroradb"
  master_password           = "DevOpsTerraStagSQL"
  final_snapshot_identifier = "final"
  skip_final_snapshot       = true
  count                     = 1
  instance_class            = "db.t3.medium"
  publicly_accessible       = false
  database_name             = "netsol"
}