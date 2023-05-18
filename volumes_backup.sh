#!/bin/bash

START=$SECONDS

# Use the commandline argument as the target directory (by default its ./ )
TARGETDIR=${1:-./}

# Make sure the targetdir has 1 slash at the end by removing any slash first, and then appending it
TARGETDIR=${TARGETDIR%/}
TARGETDIR=${TARGETDIR}/

# Create the targetdir (will be ignored if it already exists)
mkdir -p $TARGETDIR

echo "-> docker compose down"
docker compose down

# loop through each volume
for VOLUME in gitea
do
    echo "-> backup volume $VOLUME"
	docker run --rm --name="docker_volume_backup_$VOLUME" -v $VOLUME:/volume --log-driver none rboonzaijer/volume-backup backup -c none > ${TARGETDIR}backup_$VOLUME.tar # '-c none' = no compression
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