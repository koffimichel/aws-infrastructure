# Create a target group
resource "aws_lb_target_group" "utc_target_group" {
  name     = "utc-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc1.id 
  target_type = "instance"
  protocol_version = "HTTP1"

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 6
    unhealthy_threshold = 3

  }
  tags = {
    env  = "dev"
    team = "config management"
  }
}
# Attach the target group to the AWS intances
resource "aws_lb_target_group_attachment" "utc_target_group_attachment" {
  count = 4
  target_group_arn = aws_lb_target_group.utc-target-group.arn 
  target_id        = aws_instance.app_server_1.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "attach-app2" {
  target_group_arn = aws_lb_target_group.utc-target-group.arn 
  target_id        = aws_instance.app_server_2.id 
  port             = 80
}
# Listenner
resource "aws_lb_listener" "alb-http-listener" {
    load_balancer_arn = aws_lb.application-lb.arn
    port              = 80
    protocol          = "HTTP"
  
    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.utc-target-group.arn
    }
  }
# Create the load balancer
resource "aws_lb" "application-lb" {
  name               = "application-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id] 
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id, aws_subnet.public2.id]

  enable_deletion_protection = false

  tags = {
    Name = "utc-load-balancer"
    env  = "dev"
    team = "config management"
  }
}
