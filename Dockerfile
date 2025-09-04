FROM richarvey/nginx-php-fpm:3.1.6

# Installer Node.js et npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Copier la configuration nginx  
COPY docker/nginx/nginx-site.conf /etc/nginx/sites-available/default

WORKDIR /var/www/html

# Copier les fichiers
COPY . .

# Installer les dépendances PHP
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Créer la base SQLite
RUN touch /var/www/html/database/database.sqlite

# Installer les dépendances Node.js et compiler
RUN npm ci && npm run build

# Optimisations Laravel
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache

# Permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/database

EXPOSE 80
CMD ["/start.sh"]
