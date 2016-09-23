# Fedora Backup Documentation
Documentation of fedora repository backups and audits

## Backups
Two nightly dumps are made to AWS S3:

1. Point-in-time backups using Fedora export utility + SQL dump. Stored together in compressed tar file.

2. File system incremental backups (backup only of new and modified files). Stored uncompressed.

Run time: approximately 2 minutes.

## Audits
Fixity checks are performed daily.  Logs of both successful audits and failures are posted to the repo.
