#!/bin/bash

# Define variables
DB_NAME="adeben_db"
DB_USER="adeben_user"
SERVER_NAME="benade_server"
ENCRYPTED_PASSWORD_FILE="/home/vagrant/db_password.gpg"

# Check if the encrypted password file exists
if [ ! -f "$ENCRYPTED_PASSWORD_FILE" ]; then
    echo "Encrypted password file not found. Please make sure db_password.gpg exists."
    exit 1
fi

# Obtain the encrypted database password from the file
export DB_PASS=$(gpg --decrypt "$ENCRYPTED_PASSWORD_FILE")

# Update and upgrade the system
sudo apt update
sudo apt upgrade -y

# Install Apache, MySQL, PHP, Git, and other necessary packages
sudo apt install -y apache2 mysql-server php libapache2-mod-php php-mysql git

# Clone the Laravel application from GitHub
cd /var/www/html
sudo git clone https://github.com/laravel/laravel
cd laravel

# Configure Apache to serve the Laravel application with the specified server name
# Set the server name in your Apache configuration (adjust the configuration file path as needed)
echo "ServerName $SERVER_NAME" | sudo tee /etc/apache2/conf-available/"$SERVER_NAME".conf

# Enable the new server name configuration
sudo a2enconf "$SERVER_NAME"

# Copy the Laravel .env example to the actual .env file
sudo cp /var/www/laravel/.env.example /var/www/laravel/.env

# Change ownership of the Laravel application directory to the www-data user and group
sudo chown -R www-data:www-data /var/www/laravel
sudo chmod -R 755 /var/www/laravel/storage

# Create a MySQL configuration file to set the non-plain text password
sudo tee /etc/mysql/conf.d/laravel.cnf > /dev/null <<EOL
[client]
password=$DB_PASS
EOL

# Secure MySQL and set the root password
sudo mysql_secure_installation <<EOF
$DB_PASS
n
n
n
n
y
y
EOF

# Create the database and grant privileges
echo "CREATE DATABASE $DB_NAME;" | sudo mysql -u root -p$DB_PASS
echo "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';" | sudo mysql -u root -p$DB_PASS
echo "FLUSH PRIVILEGES;" | sudo mysql -u root -p$DB_PASS

# Enable the Apache rewrite module and restart Apache
sudo a2enmod rewrite
sudo service apache2 restart

echo "Deployment completed. Laravel application is ready."

