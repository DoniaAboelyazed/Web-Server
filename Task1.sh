#!/bin/bash

# Install Apache HTTP Server (httpd)
sudo yum -y install httpd

# Create directory /var/www/html/sa
sudo mkdir -p /var/www/html/sa

# Set ownership and permissions for the directory
sudo chown -R apache:apache /var/www/html/sa
sudo chmod -R 755 /var/www/html/sa

# Create the directory directive config file
sudo tee /etc/httpd/conf.d/sa.conf > /dev/null << EOL
<Directory /var/www/html/sa>
    AllowOverride All
</Directory>
EOL

# Install Apache Utilities for htpasswd
sudo yum -y install httpd-tools

# Create .htaccess file for authentication
sudo htpasswd -c /var/www/html/sa/.htpasswd username

# Add authentication configuration to .htaccess file
sudo tee /var/www/html/sa/.htaccess > /dev/null << EOL
AuthType Basic
AuthName "Restricted Content"
AuthUserFile /var/www/html/sa/.htpasswd
Require valid-user
EOL

# Start and enable Apache service
sudo systemctl start httpd
sudo systemctl enable httpd
