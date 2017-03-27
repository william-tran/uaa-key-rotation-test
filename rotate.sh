#!/bin/bash
KEYS=""
for KEY_ID in "$@"
do
	if [[ ! -z "$KEYS" ]]; then
		KEYS="$KEYS,"
	fi
	KEY=$(<$KEY_ID.pem)
	KEYS="$KEYS\"$KEY_ID\":{\"signingKey\":\"$KEY\"}"
done

ZONE_ID=$(uaac curl -H'Content-type:application/json' /identity-zones | grep -B1 "\"subdomain\": \"$ZONE_SUBDOMAIN\"" | grep '"id"' | awk '{print $2}' | sed 's/"//g' | sed 's/,//')
uaac curl -X PUT -H'Content-type:application/json' /identity-zones/$ZONE_ID -d "{\"id\":\"$ZONE_ID\",\"subdomain\": \"$ZONE_SUBDOMAIN\",\"name\": \"$ZONE_SUBDOMAIN\",\"config\":{\"tokenPolicy\":{\"keys\":{$KEYS},\"activeKeyId\":\"$1\"}}}"
