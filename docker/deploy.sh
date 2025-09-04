#!/usr/bin/env bash
echo "Running composer"
composer install --no-dev --working-dir=/var/www/html

echo "Creating SQLite database..."
touch database/database.sqlite
chmod 664 database/database.sqlite

echo "Running migrations..."
php artisan migrate --force

echo "Building assets..."
npm ci
npm run build

echo "Caching config..."
php artisan config:cache
php artisan route:cache
