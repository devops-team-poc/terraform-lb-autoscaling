resource "aws_instance" "private-ec2" {
#  ami           = data.aws_ami.ec2.id
   ami              = "ami-089c6f2e3866f0f14"
  instance_type = "t2.micro"
  user_data     = file("apache.sh")
  subnet_id = aws_subnet.private.id
  vpc_security_group_ids = [ aws_security_group.new_sg.id ]
  key_name = "demo-ohio"

  tags = {
    Name = "privateInstance"
  }
}

resource "aws_security_group" "new_sg" {
  name        = "new_sg"
  description = "Allow traffic for ec2 instance"
  vpc_id      = aws_vpc.demo_vpc.id

 ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
output  "security_group_id" {
value = [ aws_security_group.new_sg.id ]
}
