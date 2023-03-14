resource "aws_lb" "app-alb" {
  name = "app-alb"
  internal = "false"
  load_balancer_type = "application"
  subnets = [aws_subnet.public-subnet-1.id , aws_subnet.public-subnet-2.id]
  security_groups = [aws_security_group.app-sg.id]
}

resource "aws_lb_target_group" "app-target-group" {
  name = "app-target-group"
  port = "80"
  protocol = "HTTP"
  vpc_id = aws_vpc.app-vpc.id
  health_check {
    healthy_threshold = "2"
    unhealthy_threshold ="5"
    timeout = "30"
    interval = "40"
  }
  }

resource "aws_lb_listener" "app-lb-listener" {
  load_balancer_arn = aws_lb.app-alb.arn
  port = "80"
  protocol = "HTTP"
   default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-target-group.arn
  }
}