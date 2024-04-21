resource "aws_instance" "bastion_host" {
  ami = "ami-02d7fd1c2af6eead0"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.sg1.id ]
  availability_zone = "us-east-1a"
  key_name        = aws_key_pair.utc_key.key_name
  security_groups = [aws_security_group.bastion_host_sg.id]
  subnet_id = aws_subnet.private1.id
  tags = {
    env  = "dev"
    team = "config management"
  }

}
resource "null_resource" "copy_key" {
  provisioner "remote-exec" {
    inline = [
      "mkdir -p ~/.ssh",
      "echo '${aws_key_pair.utc_key.private_key}' > ~/.ssh/utc-key.pem",
      "chmod 400 ~/.ssh/utc-key.pem"
    ]

    connection {
      host        = aws_instance.bastion_host.public_ip
      type        = "ssh"
      user        = "ec2-user"  # Change this if the user is different on your AMI
      private_key = file("~/.ssh/id_rsa")  # Provide the path to your local private key for SSH access to the bastion host
    }
  }
}
resource "aws_instance" "app_server_1" {
  count = 2
  ami = "ami-02d7fd1c2af6eead0"
  instance_type = "t2.micro"
  key_name          = "utc-key"
  security_groups   = [aws_security_group.app_server_sg.id]
  availability_zone = "us-east-1b"
  subnet_id = aws_subnet.private2.id
  user_data = file("code.sh")
  tags = {
    Name = "appserver-1-${count.index + 1}"
    env  = "dev"
    team = "config management"
  }

}
resource "aws_instance" "app_server_2" {
  count = 2
  ami = "ami-02d7fd1c2af6eead0"
  instance_type = "t2.micro"
  key_name          = "utc-key"
  security_groups   = [aws_security_group.app_server_sg.id]
  availability_zone = "us-east-1c"
  subnet_id = aws_subnet.private3.id
  user_data = file("code.sh")
  tags = {
    Name = "appserver-2-${count.index + 1}"
    env  = "dev"
    team = "config management"
  }

}
resource "aws_launch_template" "app_server_launch_template" {
  name_prefix          = "app-server-launch-template"
  image_id             = "ami-02d7fd1c2af6eead0"  # Replace with the AMI ID of utcappserver
  instance_type        = "t2.micro"
  key_name             = "utc-key"
  security_group_names = [aws_security_group.app_server_sg.name]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "app-server"
      env  = "dev"
      team = "config management"
    }
  }
}

