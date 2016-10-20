#/bin/bash

# Set dates
YESTERDAY=$(date +"%Y%m%d" --date="1 day ago")
YEAR=$(date +"%Y" --date="1 day ago")
MONTH=$(date +"%m" --date="1 day ago")
# Set users for email alerts
EMAIL=""
# Configure GitHub credentials
# EX: https://username:access-key@github.com/organization/repo.git
GITHUB_CREDENTIALS=""
#Set the server URL
SERVER_URL=""

# Create folders for year and month if they don't exist already
if [ ! -d /opt/Fedora-Backup-Documentation/fixitySuccesses/$YEAR ]
	then
		mkdir /opt/Fedora-Backup-Documentation/fixitySuccesses/$YEAR
fi

if [ ! -d /opt/Fedora-Backup-Documentation/fixitySuccesses/$YEAR/$MONTH ]
	then
		mkdir /opt/Fedora-Backup-Documentation/fixitySuccesses/$YEAR/$MONTH
fi

if [ ! -d /opt/Fedora-Backup-Documentation/fixityErrors/$YEAR ]
	then
		mkdir /opt/Fedora-Backup-Documentation/fixityErrors/$YEAR
fi

if [ ! -d /opt/Fedora-Backup-Documentation/fixityErrors/$YEAR/$MONTH ]
	then
		mkdir /opt/Fedora-Backup-Documentation/fixityErrors/$YEAR/$MONTH
fi

# Record items that passed the fixity check
if [ -f /tmp/fixitySuccess.log ]
	then
		cat /tmp/fixitySuccess.log | grep -e "<rdf:Description rdf:about=" -e "sha1" | grep -v fixity >> /opt/Fedora-Backup-Documentation/fixitySuccesses/$YEAR/$MONTH/$YESTERDAY-fixitySuccesses.log
		cd /opt/Fedora-Backup-Documentation/
		git pull
		git add /opt/Fedora-Backup-Documentation/fixitySuccesses/$YEAR/$MONTH/$YESTERDAY-fixitySuccesses.log
		SUCCESSES=$(grep -e "<rdf:Description rdf:about=" /opt/Fedora-Backup-Documentation/fixitySuccesses/$YEAR/$MONTH/$YESTERDAY-fixitySuccesses.log | wc -l)
	else
		# No items passed the fixity check
		echo "Problems!"
		touch /opt/Fedora-Backup-Documentation/fixitySuccesses/$YEAR/$MONTH/$YESTERDAY-fixitySuccesses.log
		cd /opt/Fedora-Backup-Documentation/
		git pull
		git add /opt/Fedora-Backup-Documentation/fixitySuccesses/$YEAR/$MONTH/$YESTERDAY-fixitySuccesses.log
		SUCCESSES=$(grep -e "<rdf:Description rdf:about=" /opt/Fedora-Backup-Documentation/fixitySuccesses/$YEAR/$MONTH/$YESTERDAY-fixitySuccesses.log | wc -l)
fi

# Push successful fixity results to Github repo
cd /opt/Fedora-Backup-Documentation/
git commit -m "$SERVER_URL fixity results for $YESTERDAY there were $SUCCESSES successful checks."
git push $GITHUB_CREDENTIALS

# Record items that failed the fixity check
if [ -f /tmp/fixityErrors.log ]
	then
		cat /tmp/fixityErrors.log | grep -e "<rdf:Description rdf:about=" -e "sha1" | grep -v fixity >> /opt/Fedora-Backup-Documentation/fixityErrors/$YEAR/$MONTH/$YESTERDAY-fixityErrors.log
		cd /opt/Fedora-Backup-Documentation/
		git add /opt/Fedora-Backup-Documentation/fixityErrors/$YEAR/$MONTH/$YESTERDAY-fixityErrors.log
		ERRORS=$(grep -e "<rdf:Description rdf:about=" /opt/Fedora-Backup-Documentation/fixityErrors/$YEAR/$MONTH/$YESTERDAY-fixityErrors.log | wc -l)
	else
		# Some items failed the fixity check
		echo "No errors!"
		touch /opt/Fedora-Backup-Documentation/fixityErrors/$YEAR/$MONTH/$YESTERDAY-fixityErrors.log
		cd /opt/Fedora-Backup-Documentation/
		git add /opt/Fedora-Backup-Documentation/fixityErrors/$YEAR/$MONTH/$YESTERDAY-fixityErrors.log
		ERRORS=$(grep -e "<rdf:Description rdf:about=" /opt/Fedora-Backup-Documentation/fixityErrors/$YEAR/$MONTH/$YESTERDAY-fixityErrors.log | wc -l)
		echo "Fixity checks on $SERVER_URL failed for $ERRORS items.  See: https://github.com/gwu-libraries/Fedora-Backup-Documentation/tree/master/fixityErrors/$YEAR/$MONTH/$YESTERDAY-fixityErrors.log for more details" | mail -s "Fixity checks failed for $ERRORS items" $EMAILS
fi

# Push fixity error results to Github repo
cd /opt/Fedora-Backup-Documentation/
git commit -m "$SERVER_URL fixity results for $YESTERDAY there were $ERRORS errors."
git push $GITHUB_CREDENTIALS

# Clean up logs from the previous day
rm -f /tmp/fixitySuccess.log
rm -f /tmp/fixityErrors.log

# Starts fixity checks for today
curl -XPOST localhost:9080/reindexing/prod -H"Content-Type: application/json" -d '["broker:queue:fixity"]'
