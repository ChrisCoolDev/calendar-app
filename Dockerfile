# Utiliser l'image nginx-php-fpm
FROM richarvey/nginx-php-fpm:3.1.6

# Copier les fichiers de configuration
COPY docker/nginx/nginx-site.conf /etc/nginx/sites-available/default
COPY docker/php/php.ini /usr/local/etc/php/conf.d/app.ini

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier les fichiers de l'application
COPY . .

# Installer les dépendances Composer (sans dev pour la prod)
RUN composer install --no-dev --optimize-autoloader

# Définir les permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Exposer le port 80
EXPOSE 80

# Script de démarrage
CMD ["/start.sh"]
