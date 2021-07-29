# iRODS-container

Docker container for backing up a directory to iRODS

Building
--------

```bash
docker build -t uhndata/irods .
```

Running
-------

- Create an asymmetric GPG keypair (for `cardsbackupuser@localhost`)

```bash
gpg --full-generate-key
```

- Export the public key and copy to the server

```bash
gpg --output pubkey.gpg --armor --export cardsbackupuser@localhost
```

- Run the backup container

```bash
docker run --rm \
  -v $(realpath ./backup_script.sh):/backup_script.sh:ro \
  -v /dir/to/backup/:/BACKUP_DATA:ro \
  -v /path/to/pubkey.gpg:/pubkey.gpg:ro \
  -v $(realpath ~/.irods/irods_environment.json):/root/.irods/irods_environment.json:ro
  -e TZ=America/Toronto
  -e IRODS_PASSWORD=irodspassword \
  -e IRODS_COLLECTION_PATH=irods_collection_path \
  it uhndata/irods \
  /backup_script.sh
```

- To decrypt an encrypted backup

```bash
gpg --decrypt BACKUP_DATA_2021-07-29_15-22-42.tar.gz.gpg > BACKUP_DATA_2021-07-29_15-22-42.tar.gz
```
