# Create SNS topic
resource "aws_sns_topic" "utc_auto_scaling_topic" {
  name = "utc-auto-scaling"
}

# Create SNS subscription for team email
resource "aws_sns_topic_subscription" "team_email_subscription" {
  topic_arn = aws_sns_topic.utc_auto_scaling_topic.arn
  protocol  = "email"
  endpoint  = "michelnomenyo4@gmail.com"  # Replace with the team email address
}

# Configure Auto Scaling Group to publish notifications to the SNS topic
resource "aws_autoscaling_notification" "sns_notification" {
  group_names           = [aws_autoscaling_group.utc_autoscaling_group.name]
  notifications         = ["autoscaling:EC2_INSTANCE_LAUNCH", "autoscaling:EC2_INSTANCE_LAUNCH_ERROR", "autoscaling:EC2_INSTANCE_TERMINATE", "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"]
  topic_arn             = aws_sns_topic.utc_auto_scaling_topic.arn
}
