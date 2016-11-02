# Fedora Backup Documentation
Documentation of fedora repository backups and audits

## Backups
Two nightly backups are made to AWS S3:

1. _Dump_. Point-in-time backup of the entire system's content (including binaries and RDF metadata) using Fedora [Import/Export Utility](https://github.com/fcrepo4-labs/fcrepo-import-export) + a SQL dump (see also Fedora 4 [Import and Export Tools documentation](https://wiki.duraspace.org/display/FEDORA4x/Import+and+Export+Tools)). The two are stored together in compressed tar file.

2. _Sync_. File system incremental backups (backup only of new and modified files). Stored uncompressed. 

Run time: approximately 2 minutes.

## Fixity Checks
Fixity checks (aka audits*) are performed daily on the active Fedora instance to ensure that content in the digital repository has not been altered. These audits "fingerprint" every file in the repository using SHA-1, compare that fingerprint with the fingerprint on record, and report out confirmation of the files that haven't changed (success logs) and lists of any files that have changed (error logs). The audit logs are written to the repo nightly. 

### Success files [/fixitySuccesses](/fixitySuccesses)
A log of all files whose audit checks were successful (checksum unchanged) appears in /fixitySuccesses/YYYY/MM/YYYYMMDD-fixitySuccesses.log . Each daily log file includes an inventory of all  files in the Fedora repository, including the file path and SHA-1 hash. The audit is performed on all files, including thumbnails, full text (OCR) text files, characterization/metadata files, and content files themselves. These logs are committed with a message that summarizes the number of successes and errors: 

"Repository fixity results for YYYYMMDD there were ## successful checks."

### Error files [/fixityErrors](/fixityErrors)
An error log is also produced every evening, regardless of whether any files failed the audit check. These are saved to fixityErrors/YYYY/MM/YYYYMMDD-fixityErrors.log. If any files fail the audit check (defined as having an altered SHA-1 hash), they will be listed in the error log file. Otherwise, the file will be blank. These logs are committed with a message that summarizes the number of successes and errors: 

"Repository fixity results for YYYYMMDD there were ## errors."

### Scripts [/scripts](/scripts)
The [/scripts](/scripts) directory includes the nightly chron job used to create the logs.



*Fedora documentation also uses "audit" to refer to tracking repository events. We use it synonymously with fixity checks. 