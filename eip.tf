resource "aws_eip" "nat" {
  
# vpc      = true
  depends_on = [aws_internet_gateway.Igw]
  tags = {
    Name = "EIP"
  }
}
