#!/bin/bash

sudo yum update -y
sudo yum install jq -y

RDS_ENDPOINT=${vars.rds_endpoint}
RDS=$(echo "$RDS_ENDPOINT" | cut -d':' -f1)
RDS_PASSWORD=${vars.rds_password}
password=$(echo "$RDS_PASSWORD" | jq -r '.[0].password')

# Install PHP 8.2
sudo amazon-linux-extras enable php8.2
sudo yum install -y php

# Install required PHP extensions for WordPress
sudo yum install -y php-mysqlnd php-gd php-xml php-mbstring

# Install and configure Apache web server
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# Download and extract WordPress
sudo yum install -y wget
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
sudo mv wordpress/* /var/www/html/

# Configure permissions for WordPress
sudo chown -R apache:apache /var/www/html/
sudo chmod -R 700 /var/www/html/

# Update Apache configuration
echo "<Directory /var/www/html/>
    AllowOverride All
</Directory>" | sudo tee -a /etc/httpd/conf.d/wordpress.conf
 
# sudo chown -R apache:apache /var/www/html/
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sudo sed -i "s/database_name_here/wpdb/g" /var/www/html/wp-config.php
sudo sed -i "s/username_here/admin/g" /var/www/html/wp-config.php
sudo sed -i "s/password_here/$${password}/g" /var/www/html/wp-config.php
sudo sed -i "s/localhost/$${RDS}/g" /var/www/html/wp-config.php

# Restart Apache
sudo systemctl restart httpd

# Clean up temporary files
rm -rf latest.tar.gz wordpress

echo "WordPress installation completed successfully!"

