#!/bin/sh
##

# Change to web-root
cd /var/www

# Download and run Composer
wget http://getcomposer.org/composer.phar -O composer.phar
php composer.phar install --optimize-autoloader --prefer-dist

# Symfony2 actions
php app/console assets:install web --symlink

case "$ENV" in
  "Production")
    php app/console assetic:dump --env=prod
    php app/console cache:clear --env=prod
    php app/console doctrine:migrations:migrate --env=prod --no-interaction
    ;;

  "Development" | "Staging")
    php app/console assetic:dump --env=dev
    php app/console cache:clear --env=dev
    php app/console doctrine:database:create --env=dev --no-interaction
    php app/console doctrine:schema:update --force --env=dev --no-interaction
    php app/console doctrine:fixtures:load --env=dev --no-interaction
    ;;
esac

# Get rid of nasty root permissions
chown -R www-data:root /var/www

# Run Apache2
/usr/sbin/apache2ctl -D FOREGROUND
