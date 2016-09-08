# Fedora Backup Documentation
Documentation of fedora repository backups and audits

## Backups
Two nightly dumps are made to AWS S3:

1. Point-in-time backups using Fedora export utility + SQL dump. Stored together in compressed tar file.

2. File system incremental backups (backup only of new and modified files). Not compressed

Run time: approximately 2 minutes.

## Audits
Checksum audits are pending release and implementation of Fedora 4.6.