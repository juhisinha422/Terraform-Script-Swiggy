# Create a new Security Group
resource "aws_security_group" "project_sg" {
  name        = "Project-SG-unique"
  description = "Open ports 22, 80, 443, 8080, 9000, 3000"

  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000] : {
      description      = "Allow TCP port ${port}"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "Allow all outbound traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "Project-SG-unique"
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami                    = "ami-0dee22c13ea7a9a67" # Ubuntu 22.04 LTS
  instance_type          = "t2.large"
  key_name               = "Swiggy"
  vpc_security_group_ids = [aws_security_group.project_sg.id]
  user_data              = file("./resource.sh")

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = "Swiggy"
  }
}
