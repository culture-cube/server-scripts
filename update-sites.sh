#!/bin/bash
DATE="$(date +'%Y%m%d')"
BACKUPPATH=~/backups/$DATE

mkdir -p $BACKUPPATH

cd
ROOT="$(pwd)"

# First, delete backup folders older than a month
echo "Deleting old backups..."
DEL=$(date --date="30 days ago" +%Y%m%d)
for i in `find $ROOT/backups -type d -name "2*"`; do
  (($DEL > $(basename $i))) && rm -rf $i
done

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
		wp theme update --all;
		wp plugin update --all --minor;
		wp theme list;
		wp plugin list;
		wp core update;
		wp checksum core;
		wp db check;
		echo ""
	fi
done