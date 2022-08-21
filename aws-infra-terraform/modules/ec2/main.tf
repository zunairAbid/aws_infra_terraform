
// Create an aws_ami filter to choose the available AMI
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
//Create key pair for ec2

resource "aws_key_pair" "ec2-key" {
  key_name   = "${var.global_variables.project}-${var.global_variables.app}-${terraform.workspace}-key"
  public_key = var.ec2.public_key
}

// Configure EC2 instance 
resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address = var.ec2.associate_public_ip_address
  instance_type               = var.ec2.instance_type
  key_name                    = aws_key_pair.ec2-key.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security-group-id]

  tags = {
    
    "Name"= "${var.global_variables.project}-${var.global_variables.app}-${terraform.workspace}-ec2"
  }
}