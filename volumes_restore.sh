#!/bin/bash

START=$SECONDS

echo "Restore docker containers? (Existing data will be removed)."
read -p "Are you sure? (y/n) " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    
	# Use the commandline argument as the target directory (by default its ./ )
	TARGETDIR=${1:-./}

	# Make sure the targetdir has 1 slash at the end by removing any slash first, and then appending it
	TARGETDIR=${TARGETDIR%/}
	TARGETDIR=${TARGETDIR}/

	echo "-> docker compose down"
	docker compose down

	# loop through each volume
	for VOLUME in gitea
	do
		echo "-> restore volume $VOLUME"
		docker run -i --rm --name="docker_volume_restore_$VOLUME" -v $VOLUME:/volume --log-driver none rboonzaijer/volume-backup restore -f -c none < ${TARGETDIR}backup_$VOLUME.tar # -f = force, '-c none' = no compression
	done

	echo "-> docker compose up -d"
	docker compose up -d

	echo "-> docker ps --filter \"name=gitea\""
	docker ps --filter "name=gitea"

	# show how much time this took...
	DURATION=$(( SECONDS - START ))
	if (( $DURATION > 3600 )) ; then
		let "hours=DURATION/3600"
		let "minutes=(DURATION%3600)/60"
		let "seconds=(DURATION%3600)%60"
		echo "Completed in $hours hour(s), $minutes minute(s) and $seconds second(s)" 
	elif (( $DURATION > 60 )) ; then
		let "minutes=(DURATION%3600)/60"
		let "seconds=(DURATION%3600)%60"
		echo "Completed in $minutes minute(s) and $seconds second(s)"
	else
		echo "Completed in $DURATION seconds"
	fi

fi