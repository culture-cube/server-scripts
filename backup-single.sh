#!/bin/bash
echo "What site would you like to back up?"
read WEBDOMAIN

echo "Should we store the tarball in the website public folder? [Y/n]"
read FOLDERSELECT
TARLOCATION=/home/$USER/$WEBDOMAIN/public
if [ "$FOLDERSELECT" == "n" ]; then TARLOCATION=/home/$USER/backups ; fi

cd /home/$USER/$WEBDOMAIN/public
if [ -f "$TARLOCATION/db.sql" ]; then rm db.sql; fi
echo "Exporting database..."
wp db export db.sql
if [ -f "$TARLOCATION/$WEBDOMAIN.tar.gz" ]; then rm $TARLOCATION/$WEBDOMAIN.tar.gz; fi
echo "Backing up files..."
tar czf $WEBDOMAIN.tar.gz db.sql ./wp-content/plugins ./wp-content/themes ./wp-content/uploads
rm db.sql

if [ "$TARLOCATION" != /home/$USER/$WEBDOMAIN/public ]; then

   if [ -f "$TARLOCATION/$WEBDOMAIN.tar.gz" ]; then rm $TARLOCATION/$WEBDOMAIN.tar.gz; fi

   mv $WEBDOMAIN.tar.gz $TARLOCATION/$WEBDOMAIN.tar.gz

fi

echo "Finished backup of $WEBDOMAIN"