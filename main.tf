// To Automate EC2, Auto-Scaling, Load Balancer, and DNS Setup Using IAC

provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "naavathej" {
  ami           = "ami-0e2c8caa4b6378d8c" # Use the appropriate AMI ID
  instance_type = "t2.micro"
  key_name      = "Jenkins-NT" 
}

resource "aws_autoscaling_group" "NTT" {
  desired_capacity     = 3
  max_size             = 4
  min_size             = 2
  vpc_zone_identifier  = ["subnet-0cf5d79e5645bcdd7"] # Replace with your subnet ID
  launch_template {
    version = "$Latest"
    id = aws_launch_template.lt.id
  }
}

resource "aws_launch_template" "lt" {
  image_id      = "ami-0e2c8caa4b6378d8c"
  instance_type = "t2.micro"
  key_name      = "Jenkins-NT"
}

resource "aws_lb" "lb1" {
  name               = "load-balancer-22"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["subnet-0cf5d79e5645bcdd7", "subnet-0d5839a685bb64ffc"]
}

resource "aws_route53_record" "dns" {
  zone_id = "Z049742132G7AR3UKXDBO" # Replace with your Route 53 hosted zone ID
  name    = "navathej.com"
  type    = "A"

  alias {
    name                   = aws_lb.lb1.dns_name
    zone_id                = aws_lb.lb1.zone_id
    evaluate_target_health = false
  }
}