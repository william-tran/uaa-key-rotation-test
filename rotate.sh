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

uaac curl -X PUT -H'Content-type:application/json' /identity-zones/test -d "{\"id\":\"test\",\"subdomain\": \"test\",\"name\": \"test\",\"config\":{\"tokenPolicy\":{\"keys\":{$KEYS},\"activeKeyId\":\"$1\"}}}"
