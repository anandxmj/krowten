#!/bin/bash
sudo -i
yum update -y
yum install httpd -y
echo "Awsome Day Ever!" >> /var/www/html/index.html
systemctl enable --now httpd
