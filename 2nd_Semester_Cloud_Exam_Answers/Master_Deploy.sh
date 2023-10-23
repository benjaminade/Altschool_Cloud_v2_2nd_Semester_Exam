#!/bin/basih

# Update and upgrade the system
sudo apt update
sudo apt upgrade -y

# Install Apache, MySQL, PHP, Git, and other necessary packages
sudo apt install -y apache2 mysql-server php libapache2-mod-php php-mysql git

# Clone the Laravel application from GitHub
cd /var/www/html
sudo git clone https://github.com/laravel/laravel.git
cd laravel

# Configure Apache to serve the Laravel application with the specified server name
# Set the server name in your Apache configuration (adjust the configuration file path as needed)
echo "ServerName benade_server" | sudo tee /etc/apache2/conf-available/server-name.conf

# Enable the new server name configuration
sudo a2enconf server-name

# Copy the Laravel .env example to the actual .env file
sudo cp /var/www/laravel/.env.example /var/www/laravel/.env

# Change ownership of the Laravel application directory to the www-data user and group
sudo chown -R www-data:www-data /var/www/laravel
sudo chmod -R 755 /var/www/laravel/storage

# Create a MySQL configuration file to set the non-plain text password
sudo tee /etc/mysql/conf.d/laravel.cnf > /dev/null <<EOL
[client]
password=654321
EOL

# Secure MySQL and set the root password
sudo mysql_secure_installation <<EOF

654321
n
n
n
n
y
y
EOF

# Create the database and grant privileges
echo "CREATE DATABASE adeben_db;" | sudo mysql -u root -p654321
echo "GRANT ALL PRIVILEGES ON adeben_db.* TO 'adeben_user'@'localhost' IDENTIFIED BY '654321';" | sudo mysql -u root -p654321
echo "FLUSH PRIVILEGES;" | sudo mysql -u root -p654321

# Enable the Apache rewrite module and restart Apache
sudo a2enmod rewrite
sudo service apache2 restart

echo "Deployment completed. Laravel application is ready."
