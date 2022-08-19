#!/bin/bash
# Auteur : Belgotux
# Site : www.monlinux.net
# Licence : CC-BY-NC-SA (https://creativecommons.org/licenses/by-nc-sa/3.0/fr/)
# Version : 1.0
# Date : 08/03/18
# changelog
# v1.0 send by pushbullet

providerApi='https://api.pushbullet.com/v2/pushes'
accessToken=''


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
	
	tempfile=$(mktemp -p 'nutNotifyPushBullet-')
	curl -s -o $tempfile --header "Access-Token: $accessToken" --header 'Content-Type: application/json' --request POST --data-binary "{\"type\":\"note\",\"title\":\"$HOSTNAME - $subjectPushBullet\",\"body\":\"$textPushBullet\"}" "$providerApi"
	#TODO check return
	rm $tempfile
}


if [ $# != 2 ] ; then
	echo "Error : send message by argument :" 1>&2
	echo "Example : pushbullet.sh \"Title\" \"message with spaces\"" 1>&2
	exit 1
fi

sendPushBullet "$1" "$2"

exit $?