resource "aws_launch_configuration" "as_conf" {
  name          = "web_config"
  image_id      = "ami-012e7ec91bcc90a9d"
#  user_data     = file("apache.sh")
  instance_type = "t2.micro"
#  vpc_classic_link_id = "vpc-050582e77f683b875"
#  vpc_classic_link_security_groups = [ "sg-05d85f96fe110c000" ]
  key_name      =  "demo-ohio"
  security_groups    =  [ "sg-038f343d4575fb9b9" ]
}

resource "aws_autoscaling_group" "app_asg" {
  name                      = "application_asg"
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
#  load_balancers            = [ aws_alb.alb.name  ]
  target_group_arns         =  [ "arn:aws:elasticloadbalancing:us-east-2:206226350553:targetgroup/terraform-example-alb-target/aa8a9e42dcef4e6e" ]
# placement_group           = aws_placement_group.test.id
  launch_configuration      = aws_launch_configuration.as_conf.name
  vpc_zone_identifier       = [ "subnet-069ea14f0ec01bcb3" ]
}

resource "aws_autoscaling_policy" "AddInstancesPolicy" {
  name                   = "AddInstancesPolicy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}
  
resource "aws_autoscaling_policy" "RemoveInstancesPolicy" {
  name                   = "RemoveInstancesPolicy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}
  
resource "aws_cloudwatch_metric_alarm" "avg_cpu_ge_50" {
  alarm_name                = "avg_cpu_ge_60"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "50"

dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.AddInstancesPolicy.arn]
}  

resource "aws_cloudwatch_metric_alarm" "avg_cpu_le_30" {
  alarm_name                = "avg_cpu_ge_30"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "30"

dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.RemoveInstancesPolicy.arn]
}  

