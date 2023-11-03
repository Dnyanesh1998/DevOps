#! /bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo service httpd start
echo "Homepage for web-application" >> /var/www/html/index.html
sudo systemctl enable httpd

