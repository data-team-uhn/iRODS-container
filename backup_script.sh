#!/bin/bash

BACKUP_FILENAME="BACKUP_DATA_$(date +%F_%H-%M-%S)"

# Create a .tar.gz archive of /BACKUP_DATA
tar -zcvf "$BACKUP_FILENAME.tar.gz" /BACKUP_DATA || { echo "Failed to create $BACKUP_FILENAME.tar.gz"; exit -1; }

# Encrypt the .tar.gz archive
gpg --encrypt --cipher-algo AES256 --recipient-file /pubkey.gpg "$BACKUP_FILENAME.tar.gz" || { echo "Failed to create $BACKUP_FILENAME.tar.gz.gpg"; exit -1; }

# Remove the .tar.gz archive - we no longer need it
rm "$BACKUP_FILENAME.tar.gz" || { echo "Failed to remove $BACKUP_FILENAME.tar.gz"; exit -1; }

# Login to iRODS
ls ~/.irods/irods_environment.json || { echo "~/.irods/irods_environment.json does not exist!"; exit -1; }
printenv IRODS_PASSWORD | iinit || { echo "Failed to login to iRODS"; exit -1; }

# Copy to iRODS
icd $IRODS_COLLECTION_PATH || { echo "Failed to enter iRODS collection $IRODS_COLLECTION_PATH"; exit -1; }
iput "$BACKUP_FILENAME.tar.gz.gpg" || { echo "Failed to upload $BACKUP_FILENAME.tar.gz.gpg to iRODS"; exit -1; }

# Compute the hash of $BACKUP_FILENAME.tar.gz.gpg
sha256sum "$BACKUP_FILENAME.tar.gz.gpg"
echo "Sucessfully backed up $BACKUP_FILENAME"
