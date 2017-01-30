#!/bin/bash
uaac target http://localhost:8080/uaa
uaac token client get admin -s adminsecret
uaac curl -X POST /identity-zones -H'Content-type:application/json' -d '{"id":"test","name":"test","subdomain":"test"}'
uaac -z test client add myclient -s mysecret --authorized_grant_types=client_credentials --authorities=api.read
./rotate.sh 0 1
