FROM richarvey/nginx-php-fpm:3.1.6

# Copier la configuration nginx
COPY docker/nginx/nginx-site.conf /etc/nginx/sites-available/default

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier tous les fichiers du projet
COPY . .

# Installer les dépendances Composer
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Créer la base de données SQLite si nécessaire
RUN touch /var/www/html/database/database.sqlite

# Installer les dépendances Node.js et compiler les assets
RUN npm ci && npm run build

# Exécuter les optimisations Laravel
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache

# Définir les permissions correctes
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/database

# Exposer le port 80
EXPOSE 80

# Commande de démarrage
CMD ["/start.sh"]
