resource "aws_autoscaling_group" "asg_webapp" {
  name = "webapp_asg"

  launch_template {
    id      = aws_launch_template.asg_lt.id
    version = "$Latest"
  }

  vpc_zone_identifier = [for subnet in module.public_subnet.public_subnets : subnet.id]
  min_size            = 1
  max_size            = 3
  desired_capacity    = 1
  default_cooldown    = 60

  tag {
    key                 = "Name"
    value               = "webapp_asg"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_launch_template.asg_lt]

  target_group_arns = [
    aws_lb_target_group.webapp_lb_tg.arn
  ]
}

resource "aws_autoscaling_policy" "asg_cpu_up_policy" {
  name                   = "scale_up_policy"
  policy_type            = var.policy_type
  scaling_adjustment     = 1
  adjustment_type        = var.adjustment_type
  autoscaling_group_name = aws_autoscaling_group.asg_webapp.id
}

resource "aws_autoscaling_policy" "asg_cpu_down_policy" {
  name                   = "scale_down_policy"
  policy_type            = var.policy_type
  scaling_adjustment     = -1
  adjustment_type        = var.adjustment_type
  autoscaling_group_name = aws_autoscaling_group.asg_webapp.id
}

resource "aws_cloudwatch_metric_alarm" "cpu_high_utilization_metric" {
  alarm_name          = "cpu_high_utilization_metric"
  alarm_description   = "Alarm to increment ec2-instance by 1 when average CPU utilization exceeds 5%"
  evaluation_periods  = "1"
  metric_name         = var.autoscale_metric_name
  comparison_operator = "GreaterThanThreshold"
  namespace           = var.autoscale_metric_namespace
  period              = "120"
  statistic           = "Average"
  threshold           = "5"
  alarm_actions       = [aws_autoscaling_policy.asg_cpu_up_policy.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg_webapp.id
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_low_utilization_metric" {
  alarm_name          = "cpu_low_utilization_metric"
  alarm_description   = "Alarm to decrement ec2-instance by 1 when average CPU utilization goes below 3%"
  evaluation_periods  = "1"
  metric_name         = var.autoscale_metric_name
  comparison_operator = "LessThanThreshold"
  namespace           = var.autoscale_metric_namespace
  period              = "120"
  statistic           = "Average"
  threshold           = "3"
  alarm_actions       = [aws_autoscaling_policy.asg_cpu_down_policy.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg_webapp.id
  }
}