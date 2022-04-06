resource "aws_lb" "assignment" {
  name               = "assignment"
  internal           = false
  subnets            = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public-web-sg.id] #,aws_security_group.private-sg.id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.assignment.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "use /jenkins or /app to reach applications"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_rule" "jenkins" {
  listener_arn = aws_lb_listener.http.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.assignment-jenkins-target-group.arn
  }

  condition {
    path_pattern {
      values = var.alb_listener_rule_path_pattern_jenkins
    }
  }
}


resource "aws_lb_listener_rule" "app" {
  listener_arn = aws_lb_listener.http.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.assignment-app-target-group.arn
  }

  condition {
    path_pattern {
      values = var.alb_listener_rule_path_pattern_app
    }
  }
}


resource "aws_lb_target_group" "assignment-jenkins-target-group" {
  name                 = "assignment-jenkins"
  port                 = "8080"
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = "30"
  depends_on           = [aws_lb.assignment]
}

resource "aws_lb_target_group" "assignment-app-target-group" {
  name                 = "assignment-app"
  port                 = "8080"
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = "30"
  depends_on           = [aws_lb.assignment]
}



resource "aws_lb_target_group_attachment" "jenkins" {
  target_group_arn = aws_lb_target_group.assignment-jenkins-target-group.arn
  target_id        = aws_instance.jenkins-instance.private_ip
  port             = 8080
}

resource "aws_lb_target_group_attachment" "app" {
  target_group_arn = aws_lb_target_group.assignment-app-target-group.arn
  target_id        = aws_instance.app-instance.private_ip
  port             = 8080
}
