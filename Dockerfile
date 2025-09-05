FROM richarvey/nginx-php-fpm:3.1.6

# Copier la configuration nginx
COPY docker/nginx/nginx-site.conf /etc/nginx/sites-available/default

WORKDIR /var/www/html

# Copier tous les fichiers (y compris public/build déjà compilé)
COPY . .

# Installer les dépendances Composer
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Créer la base de données SQLite
RUN touch database/database.sqlite
RUN chmod 664 database/database.sqlite

# Exécuter les migrations et optimisations Laravel
RUN php artisan migrate --force
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache

# Définir les permissions
RUN chown -R www-data:www-data storage bootstrap/cache database

EXPOSE 80
CMD ["/start.sh"]
