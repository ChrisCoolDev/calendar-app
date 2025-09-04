# Stage 1: Build des assets avec Node.js officiel
FROM node:18-alpine AS assets-builder

WORKDIR /app

# Copier les fichiers de configuration Node.js
COPY package*.json ./
COPY vite.config.js ./
COPY tailwind.config.js ./

# Installer les dépendances
RUN npm ci --only=production

# Copier les ressources nécessaires au build
COPY resources/ ./resources/

# Compiler les assets
RUN npm run build

# Stage 2: Image PHP de production
FROM richarvey/nginx-php-fpm:3.1.6

# Copier la configuration Nginx
COPY docker/nginx/nginx-site.conf /etc/nginx/sites-available/default

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier tous les fichiers de l'application
COPY . .

# Copier les assets compilés depuis le premier stage
COPY --from=assets-builder /app/public/build ./public/build

# Installer les dépendances Composer
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Créer la base de données SQLite
RUN touch database/database.sqlite

# Exécuter les optimisations Laravel
RUN php artisan config:cache

# Définir les permissions
RUN chown -R www-data:www-data storage bootstrap/cache database

# Exposer le port
EXPOSE 80

# Commande de démarrage
CMD ["/start.sh"]
