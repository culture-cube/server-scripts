#!/bin/bash
DATE="$(date +'%Y%m%d')"
BACKUPPATH=~/backups/$DATE

mkdir -p $BACKUPPATH

cd
ROOT="$(pwd)"

# For each site, run updates and backups
for SITE in $(ls $ROOT); do
	if [ -d $ROOT/$SITE/public ]; then
		echo "Processing $SITE..."
		cd $ROOT/$SITE/public

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