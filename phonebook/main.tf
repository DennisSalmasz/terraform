data "aws_vpc" "selected" {
  default = true
}

data "template_file" "phonebook" {
  template = file("user-data.sh")
  vars = {
    user-data-git-token = var.git-token
    user-data-git-name = var.git-name
  }
}

resource "aws_instance" "instance" {
  ami = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name = var.key-name
  security_groups = ["WebServerSecurityGroup"] 
  depends_on = [github_repository_file.dbendpoint]
  user_data = base64encode(data.template_file.phonebook.rendered)
  tags = {
    Name = "terraform-instance"
  }
}  

resource "github_repository_file" "dbendpoint" {
  content = aws_db_instance.db-server.address
  file = "dbserver.endpoint"
  repository = "phonebook"
  overwrite_on_create = true
  branch = "main"
}

resource "aws_db_instance" "db-server" {
  instance_class = "db.t2.micro"
  allocated_storage = 20
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  allow_major_version_upgrade = false
  auto_minor_version_upgrade = true
  backup_retention_period = 0
  identifier = "phonebook-app-db"
  db_name = "phonebook"
  engine = "mysql"
  engine_version = "8.0.28"
  username = "admin"
  password = "Oliver_1"
  monitoring_interval = 0
  multi_az = false
  port = 3306
  publicly_accessible = false
  skip_final_snapshot = true
}








