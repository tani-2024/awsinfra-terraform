resource "aws_key_pair" "dove-key" {
  key_name   = "dovekey"
  public_key = file(var.PUB_KEY)
}

resource "aws_instance" "public-instance" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.dove-pub-2.id
  key_name               = aws_key_pair.dove-key.key_name
  vpc_security_group_ids = [aws_security_group.dove_stack_sg.id]
  tags = {
    Name = "public-instance"
  }
  provisioner "file" {
    source      = "web1.sh"
    destination = "/tmp/web1.sh"
  }

  provisioner "remote-exec" {

    inline = [
      "chmod +x /tmp/web1.sh",
      "sudo /tmp/web1.sh"
    ]
  }

  connection {
    user        = var.USER
    private_key = file("dovekey")
    host        = self.public_ip
  }
}


resource "aws_launch_configuration" "lc" {
  name          = "launch-configuration"
  image_id      =  var.AMIS[var.REGION]
  instance_type = "t2.micro"
  key_name      = aws_key_pair.dove-key.key_name
  security_groups = [aws_security_group.dove_stack_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Running user data script"
              yum update -y
              yum install -y httpd
              service httpd start
              chkconfig httpd on
              EOF

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.dove-priv-1.id, aws_subnet.dove-priv-2.id]
  launch_configuration = aws_launch_configuration.lc.name
  target_group_arns    = [aws_lb_target_group.my_target_group.arn]

  tag {
    key                 = "Name"
    value               = "autoscaling-instance"
    propagate_at_launch = true
  }
}






