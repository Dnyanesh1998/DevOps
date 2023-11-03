# creating instance

resource "aws_instance" "server" {
  ami                    = "ami-06006e8b065b5bd46"
  instance_type          = "t2.micro"
  key_name               = "Linux"
  subnet_id              = aws_subnet.subnet-a.id
  vpc_security_group_ids = [aws_security_group.dev-sg.id]
  user_data              = file("httpd.sh")
  count                  = 3
  tags = {
    Name = "server-${count.index}"
  }
}

