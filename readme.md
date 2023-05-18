# Gitea in Docker (compose)

# 1. Clone this repo
```
git clone git@github.com:rboonzaijer/gitea-docker.git

cd gitea-docker
```

# 2. Setup

Make each '{file}.sh' file executable
```
chmod +x *.sh
```

# 3. First run
```
docker compose up -d
```
Navigate to: http://localhost:3000

- SSH Server Port: 222
- Check: Enable Update Checker
- Server and Third-Party Service Settings > Enable Local Mode (+ Disable Gravater)
- Server and Third-Party Service Settings > Disable Self-Registration
- Server and Third-Party Service Settings > Require Sign-In to View Pages
- Administrator Account Settings > (create account)

Click: Install Gitea

http://localhost:3000/user/settings/appearance

- Language: English

( now upload your SSH keys and try out a git clone with http and SSL )


# 4. Backup/Restore

## Backup
This will shut down the container, create backups from the volumes, and then run the container again:
```
./volumes_backup.sh
# or
./volumes_backup.sh ./../my_backup_dir/
```

## Restore
This will shut down the container, restore (overwrite!) the backup files into the volumes, and start the container again.
```
./volumes_restore.sh
# or
./volumes_restore.sh ./../my_backup_dir/
```

# 5. Update gitea version

First, set the new version number in 'docker-compose.yml'.
Check the latest version number here: https://dl.gitea.com/gitea/version.json

Then run:
```
docker compose pull && docker compose up -d --remove-orphans
```

You might want to remove old images, show all images with `docker images`

To remove an old unused image:
```
docker rmi gitea/gitea:1.19.0
```
