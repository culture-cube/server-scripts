#!/bin/bash

# Confirm before running plugin updates
read -r -p "Are you sure you want to update plugins for all sites on this server? [y/N] " RESPONSE

	if [[ "$RESPONSE" =~ ^([yY][eE][sS]|[yY])$ ]]; then

		BACKUPPATH=~/backups

		# For each site, run updates and backups
		for SITE in $(ls $ROOT); do
			if [ -d $ROOT/$SITE/public ]; then
				echo "Processing $SITE..."
				cd $ROOT/$SITE/public

				# First backup the site
				echo "Backing up $SITE..."
				if [ -f "$SITE.sql" ]; then rm $SITE.sql; fi
				echo "Exporting database..."
				wp db export $SITE.sql
				if [ -f "$BACKUPPATH/$SITE.tar.gz" ]; then rm $BACKUPPATH/$SITE.tar.gz; fi
				echo "Backing up files..."
				tar czf $BACKUPPATH/$SITE.tar.gz $SITE.sql ./wp-content/plugins ./wp-content/themes ./wp-content/uploads
				rm $SITE.sql;

				# Run updates
				wp theme update --minor;
				wp plugin update --minor;
				wp theme list;
				wp plugin list;
				wp core update;
				wp checksum core;
				wp db check;
				echo ""
			fi
		done

	fi