resource "aws_security_group" "asg_sec_group" {
  name = "asg_sec_group"
  description = "Security Group for the ASG"
  
  tags = {
    name = "sg_demo"
  }
  // outbound 
  egress {
    from_port = 0
    protocol = "-1" // ALL Protocols
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  // inbound
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "myFirstInstance" {
  ami           = "ami-0cff7528ff583bf9a"
  key_name = "Mykeypair"
  instance_type = "t2.micro"
  security_groups= [ "asg_sec_group"]
  iam_instance_profile = "${aws_iam_instance_profile.main.name}"
  user_data = <<-EOF
            #!/bin/bash
            sudo yum -y update
            sudo yum install ruby -y
            sudo yum install wget -y
            cd /home/ec2-user
            sudo wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
            chmod +x ./install
            sudo ./install auto
            sudo service codedeploy-agent start
            sudo chkconfig codedeploy-agent on
            EOF

  tags= {
    Name = "instance"
  }
}