resource "aws_security_group" "playground" {
  vpc_id = aws_vpc.krowten.id
  name = "playground"
  ingress  {
    description = "Allow SSH"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  ingress {
    description = "Allow HTTP"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }
  egress {
    description = "Allow HTTP"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "all"
  }
  tags = {
    Project = "krowten" 
    Name = "playground"
  }
}

resource "aws_launch_template" "playground" {
  name = "playground"
  image_id = "ami-022e1a32d3f742bd8"
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    aws_security_group.playground.id
  ]
  user_data = filebase64("files/userdata.script")
  tags = {
    Project = "krowten"
  }
}

resource "aws_autoscaling_group" "playground" {
  name = "playground"
  vpc_zone_identifier = [
    aws_subnet.public-us-east-1d.id,
    aws_subnet.public-us-east-1e.id,
    aws_subnet.public-us-east-1f.id
  ]
  min_size = 1
  max_size = 5
  target_group_arns = [ aws_lb_target_group.playground.arn ]
  launch_template {
    id = aws_launch_template.playground.id
    version = aws_launch_template.playground.latest_version
  }
  health_check_type = "ELB"
}

resource "aws_lb_target_group" "playground" {
  load_balancing_cross_zone_enabled = true  
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.krowten.id
}

resource "aws_lb" "playground" {
  name = "playground"
  subnets = [ 
    aws_subnet.public-us-east-1d.id,
    aws_subnet.public-us-east-1e.id,
    aws_subnet.public-us-east-1f.id
  ]
}


resource "aws_lb_listener" "playground" {
  load_balancer_arn = aws_lb.playground.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.playground.arn
      }
    }
  }
}





