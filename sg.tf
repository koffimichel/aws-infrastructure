#Security group for ALB
resource "aws_security_group" "alb_sg" {
    name = "alb-sg"
    description = "Allow http and https"
    vpc_id = aws_vpc.vpc1.id
    
    
    ingress {
        description = "allow http"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  
    }
    ingress {
        description = "allow https"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  tags= {
    env = "Dev"
    team = "config management"
  }
} 

#Security group for bation-host-sg
resource "aws_security_group" "bastion_host_sg" {
    name = "bastion-host-sg"
    description = "Security group for Bastion Host"
    vpc_id = aws_vpc.vpc1.id
    
    ingress {
        description = "allow ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  tags= {
    env = "Dev"
    team = "config management"
  } 
}

#Security group for server
resource "aws_security_group" "app_server_sg" {
    name = "app-server-sg"
    description = "Security group for App Server"
    vpc_id = aws_vpc.vpc1.id
    
    ingress {
        description = "allow http"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        security_groups = [ aws_security_group.alb_sg.id ]
    }
    ingress {
        description = "allow ssh"
        from_port = 22
        to_port = 22        
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        security_groups = [ aws_security_group.bastion_host_sg.id ]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  tags= {
    env = "Dev"
    team = "config management"
  } 
}

#Security group for database
resource "aws_security_group" "database_sg" {
    name = "database-sg"
    description = "Security group for Database"
    vpc_id = aws_vpc.vpc1.id
    ingress {
        description = "allow mysql"
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        security_groups = [aws_security_group.app_server_sg.id]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  tags = {
    env  = "dev"
    team = "config management"
  }
}
