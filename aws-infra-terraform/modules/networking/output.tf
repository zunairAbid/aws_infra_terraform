output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "public_subnet" {
  value = aws_subnet.public_subnet[0].id
}

output "private_subnet" {
  value = aws_subnet.private_subnet.*.id
}

output "default_sg_id" {
  value = aws_security_group.default.id
}

output "public_route_table" {
  value = aws_route_table.public.id
}

output "private_route_table" {
  value = aws_route_table.private.id
}