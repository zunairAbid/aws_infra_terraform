output "instance-sg-id" {
  value = aws_security_group.allow_80_443.id
}

output "rds-sg-id" {
  value = aws_security_group.rds-sg.id
}