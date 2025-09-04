FROM richarvey/nginx-php-fpm:3.1.6

WORKDIR /var/www/html
COPY . .

# Créer la base de données SQLite
RUN touch database/database.sqlite
RUN chmod 664 database/database.sqlite

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/database

EXPOSE 80
CMD ["/start.sh"]
