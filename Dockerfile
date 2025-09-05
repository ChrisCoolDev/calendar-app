FROM richarvey/nginx-php-fpm:3.1.6

# Définir seulement le webroot
ENV WEBROOT /var/www/html/public

WORKDIR /var/www/html
COPY . .

# Le reste de votre Dockerfile...
RUN composer install --no-dev --optimize-autoloader --no-interaction
RUN touch database/database.sqlite
RUN chmod 664 database/database.sqlite
RUN php artisan migrate --force
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache
RUN chown -R www-data:www-data storage bootstrap/cache database

EXPOSE 80
CMD ["/start.sh"]
