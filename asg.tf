resource "aws_autoscaling_group" "utc_autoscaling_group" {
  name                        = "utc-autoscaling-group"
  launch_template {
    id                        = aws_launch_template.app_server_launch_template.id
    version                   = "$Latest"
  }
  vpc_zone_identifier         = [aws_subnet.private1.id, aws_subnet.private2.id, aws_subnet.private3.id]
  target_group_arns           = [aws_lb_target_group.utc_target_group.arn]
  min_size                    = 1
  max_size                    = 5
  desired_capacity            = 2

  metrics_granularity = "1Minute"

  tag {
    key                       = "Name"
    value                     = "app-server"
    propagate_at_launch      = true
  }

  dynamic "scaling_policy" {
    for_each = {
      scale_out = {
        name                  = "scale-out-policy"
        adjustment_type       = "ChangeInCapacity"
        scaling_adjustment    = 1
        cooldown              = 300
      },
      scale_in = {
        name                  = "scale-in-policy"
        adjustment_type       = "ChangeInCapacity"
        scaling_adjustment    = -1
        cooldown              = 300
      }
    }
    content {
      name                  = scaling_policy.value.name
      adjustment_type       = scaling_policy.value.adjustment_type
      scaling_adjustment    = scaling_policy.value.scaling_adjustment
      cooldown              = scaling_policy.value.cooldown

      target_tracking_configuration {
        predefined_metric_specification {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value            = scaling_policy.key == "scale_out" ? 80 : 20
      }
    }
  }
}
