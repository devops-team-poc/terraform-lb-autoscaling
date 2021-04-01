
resource "aws_security_group" "alb" {
  name        = "terraform_alb_security_group"
  description = "Terraform load balancer security group"
  vpc_id      = "vpc-0a97aaef4f3621a39"

   ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-example-alb-security-group"
  }
}

resource "aws_alb" "alb" {
  name            = "terraform-example-alb"
  security_groups = ["${aws_security_group.alb.id}"]
  subnets         = ["subnet-0e601385d7ca61d07","subnet-00d5e9459b14bbe8c"]
  tags = {
    Name = "terraform-example-alb"
  }
}

resource "aws_alb_target_group" "group" {
  name     = "terraform-example-alb-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0a97aaef4f3621a39"
  # Alter the destination of the health check to be the login page.
  health_check {
    path = "/"
    port = 80
  }
}
resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_alb_target_group.group.arn
  target_id        = "i-0876bde3db1b0b0a5"
  port             = 80
}

resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.group.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_alb_listener.listener_http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.group.arn}"
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}
