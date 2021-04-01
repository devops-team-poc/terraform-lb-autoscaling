resource "aws_instance" "web" {
  ami           = "ami-089c6f2e3866f0f14"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.id
  key_name      = "demo-ohio"
  vpc_security_group_ids = [ aws_security_group.new_sg.id ]
  tags = {
    Name = "BastionHost"
  }
}
