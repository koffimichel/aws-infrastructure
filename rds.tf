resource "aws_db_instance" "utc_dev_database" {
  identifier            = "utc-dev-database"
  engine                = "mysql"
  engine_version        = "5.7"  # Change the version if needed
  instance_class        = "db.t2.micro"  # Adjust instance class as needed
  allocated_storage     = 20  # Adjust storage size as needed
  username              = "utcuser"
  password              = "utcdev12345"
  publicly_accessible   = false  # Change to true if needed
  multi_az              = false  # Change to true for Multi-AZ deployment
  storage_type          = "gp2"  # Change storage type if needed
  tags = {
    Name = "utc-dev-database"
    env  = "dev"
    team = "config management"
  }
}
