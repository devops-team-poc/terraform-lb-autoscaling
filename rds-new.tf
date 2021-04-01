
resource "aws_db_instance" "mysql_rds" {
  identifier           = "mysql-rds"
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "user1"
  password             = "redhat1234"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.mysql_subnet.id
}

resource "aws_db_subnet_group" "mysql_subnet" {
  name       = "mysql-subnet"
  subnet_ids = [ "subnet-069ea14f0ec01bcb3","subnet-08ef32c95b30ed9fa"  ]

  tags = {
    Name = "My DB subnet group"
  }
} 

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow traffic for rds"
  vpc_id      = "vpc-0a97aaef4f3621a39"

 ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
