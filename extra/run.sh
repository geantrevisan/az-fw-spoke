#!/bin/bash
sudo apt update -y
sudo apt install -y apache2 unzip wget
sudo systemctl start apache2
sudo systemctl enable apache2
wget https://github.com/geantrevisan/az-fw-spoke/raw/main/extra/b3.zip
rm -rf /var/www/html/index.html
unzip b3.zip -d /var/www/html/