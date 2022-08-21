# Instances Security Group (sg)

resource "aws_security_group" "allow_80_443" {
  vpc_id      = var.vpc_id
  name        = "${var.global_variables.project}-${var.global_variables.app}-${terraform.workspace}-instance_sg"
  description = "Allow inbound traffic on port(80/443, 22) and egress(outside world) traffic"
  tags = {
    Name = "${var.global_variables.project}-${var.global_variables.app}-${terraform.workspace}-instance-sg"
  }
}

resource "time_sleep" "wait_for_allow_80_443" {
  depends_on = [aws_security_group.allow_80_443]

  create_duration = "10s"
}

resource "aws_security_group_rule" "inbound_port80" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_80_443.id
  depends_on = [time_sleep.wait_for_allow_80_443]
}

resource "aws_security_group_rule" "inbound_port443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_80_443.id
  depends_on = [time_sleep.wait_for_allow_80_443]
}

resource "aws_security_group_rule" "internal_ssh_port" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.allow_80_443.id
  depends_on = [time_sleep.wait_for_allow_80_443]
}

resource "aws_security_group_rule" "outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_80_443.id
  depends_on = [time_sleep.wait_for_allow_80_443]
}

# RDS security group (sg)

resource "aws_security_group" "rds-sg" {
  vpc_id      = var.vpc_id
  name        = "${var.global_variables.project}-${var.global_variables.app}-${terraform.workspace}-rds-sg"
  description = "Allow inbound traffic on port (3306) and outbound (outside world) traffic"
  tags = {
    Name = "${var.global_variables.project}-${var.global_variables.app}-${terraform.workspace}-rds-sg"
  }
}

resource "time_sleep" "wait_for_allow_3306" {
  depends_on = [aws_security_group.rds-sg]

  create_duration = "10s"
}

resource "aws_security_group_rule" "inbound_port3306" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [var.ec2_sg_cidr_block]
  security_group_id = aws_security_group.rds-sg.id
  depends_on        = [time_sleep.wait_for_allow_3306]
}

resource "aws_security_group_rule" "outbound_rds" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds-sg.id
  depends_on        = [time_sleep.wait_for_allow_3306]
}