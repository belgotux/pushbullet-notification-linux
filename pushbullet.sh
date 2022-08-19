#!/bin/bash
# Auteur : Belgotux
# Site : www.monlinux.net
# Licence : CC-BY-NC-SA (https://creativecommons.org/licenses/by-nc-sa/3.0/fr/)
# Version : 1.1
# First Date : 08/03/18

. $(dirname $0)/$(basename $0 .sh).conf


#send push notification with pushbullet
# see https://www.pushbullet.com
# $1 title
# $2 text body - default $textPushBullet
function sendPushBullet {
	#replace default mesg
	if [ "$1" != "" ] ; then
		subjectPushBullet=$1
	fi
	if [ "$2" != "" ] ; then
		textPushBullet=$2
	fi
	
	#var verification
	if [ "$providerApi" == "" ] || [ "$accessToken" == "" ] ; then
		echo "Can't sen push notification without complete variables for PushBullet" 1>&2
		addLog "Can't sen push notification without complete variables for PushBullet"
		return 1
	fi
	
	tempfile=$(mktemp --suffix '.nutNotifyPushBullet')
	curl -s -o "$tempfile" --header "Access-Token: $accessToken" --header 'Content-Type: application/json' --request POST --data-binary "{\"type\":\"note\",\"title\":\"$HOSTNAME - $subjectPushBullet\",\"body\":\"$textPushBullet\"}" "$providerApi"
	returnCurl=$?
	if [ $returnCurl -ne 0 ] ; then cat $tempfile ; fi
	rm $tempfile
	return $?
}

function aide() {
	echo "$0 \"title\" \"message with space\""
}

# add to log
function addLog() {
	if [ "$logfile" == "" ] ; then
		echo "Can't write to log !" 1>&2
		return 1
	else
		echo "$(date +'%a %d %H:%M:%S') $1" >> $logfile
		return $?
	fi
}

if [ $# -eq 1 ] && ( [ $? == '-h' ] || [ $? == '--help' ] ) ; then
	aide
	exit 0
elif [ $# -ne 2 ] ; then
	echo "Error : argument mal formated! Use like below" 1>&2
	aide
	exit 1
fi

sendPushBullet "$1" "$2"

exit $?