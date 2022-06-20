#!/bin/bash

echo "Which site are we restoring?"
read WEBDOMAIN
SITE_ROOT=/home/$USER/$WEBDOMAIN/public

echo "Is the backup located in the public folder of the site? [Y/n]"
read WHERE
TARLOCATION=$SITE_ROOT
if [ "$WHERE" == "n" ]; then TARLOCATION=/home/$USER/backups ; fi

# Create folder for extracted files
UNTAR=/home/$USER/untar
if [ -d $UNTAR ]; then rm -Rf $UNTAR; fi
mkdir $UNTAR
echo "Unpacking site archive: $WEBDOMAIN.tar.gz"
tar xf "$TARLOCATION/$WEBDOMAIN.tar.gz" -C $UNTAR --checkpoint=.1000 --totals

echo "Copying migrated files..."
cd $UNTAR
# Rsync the downloaded files to the current website
rsync -aqP ./wp-content/plugins/ $SITE_ROOT/wp-content/plugins/
rsync -aqP ./wp-content/themes/ $SITE_ROOT/wp-content/themes/
rsync -aqP ./wp-content/uploads/ $SITE_ROOT/wp-content/uploads/

echo "Importing database..."
# Use WP CLI to restore the original database
cd $SITE_ROOT
sed -i "s/'wp_';/'$PREFIX';/g" wp-config.php
wp db import $UNTAR/db.sql

rm -rf $UNTAR

echo "Finished restoring $WEBDOMAIN"