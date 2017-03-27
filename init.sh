#!/bin/bash
export ZONE_SUBDOMAIN=test
uaac target http://localhost:8080/uaa
uaac token client get admin -s adminsecret
uaac curl -X POST /identity-zones -H'Content-type:application/json' -d "{\"id\":\"$ZONE_SUBDOMAIN\",\"name\":\"$ZONE_SUBDOMAIN\",\"subdomain\":\"$ZONE_SUBDOMAIN\"}"
uaac -z $ZONE_SUBDOMAIN client add myclient -s mysecret --authorized_grant_types=client_credentials --authorities=api.read
./rotate.sh 0 1
