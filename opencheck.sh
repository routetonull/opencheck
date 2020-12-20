#!/usr/bin/env bash
# https://github.com/routetonull/opencheck
if [ "$CISCO_API_KEY" ] && [ "$CISCO_CLIENT_SECRET" ]
then
if [ "$1" ] && [ "$2" ]
then
    token=$(curl -s -k \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -X POST \
    -d "client_id=$CISCO_API_KEY" \
    -d "client_secret=$CISCO_CLIENT_SECRET" \
    -d "grant_type=client_credentials" \
    https://cloudsso.cisco.com/as/token.oauth2 | jq -r ".access_token")

    platform="$1"
    version="$2"

    export platform=$platform
    export version=$version

    output=$(curl -s -k \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -X GET \
    -H "Accept: application/json" \
    -H "Authorization: Bearer $token" \
    https://api.cisco.com/security/advisories/$platform?version=$version) 
    
    errorcode=$(echo $output | jq ".errorCode")
    if test ! $errorcode == null
    then
        echo "ERROR: $errorcode"
    else
        echo $output| jq | j2 -f json openvuln.j2 - > vuln-$platform-$version.md
        echo "CREATED FILE vuln-$platform-$version.md"
    fi 
else 
    echo "ERROR: Missing parameters platform and version"
fi
else
    echo "ERROR: Missing credentials CISCO_API_KEY and CISCO_CLIENT_SECRET"
fi