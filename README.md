# Fedora Backup Documentation
Documentation of fedora repository backups and audits

## Backups
Two nightly dumps are made to AWS S3:

1. Point-in-time backups using Fedora export utility + SQL dump. Stored together in compressed tar file.

2. File system incremental backups (backup only of new and modified files). Stored uncompressed.

Run time: approximately 2 minutes.

## Audits
Fixity checks are performed daily. Logs of audits, including successes and errors, are written to the repo nightly. 

### Success files /fixitySuccesses
A log of all files whose audit checks were successful (checksum unchanged) appears in /fixitySuccesses/YYYY/MM/YYYYMMDD-fixitySuccesses.log . Each daily log file includes an inventory of all  files in the Fedora repository, including the file path and SHA-1 hash. The audit is performed on all files, including thumbnails, full text (OCR) text files, characterization/metadata files, and content files themselves. These logs are committed with a message that summarizes the number of successes and errors: 

"Repository fixity results for YYYYMMDD there were ## successful checks."

### Error files /fixityErrors
An error log is also produced every evening, regardless of whether any files failed the audit check. These are saved to fixityErrors/YYYY/MM/YYYYMMDD-fixityErrors.log. If any files fail the audit check (defined as having an altered SHA-1 hash), they will be listed in the error log file. Otherwise, the file will be blank. These logs are committed with a message that summarizes the number of successes and errors: 

"Repository fixity results for YYYYMMDD there were ## errors."