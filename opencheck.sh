#!/usr/bin/env bash
# https://github.com/routetonull/opencheck

# verify requirements
which j2 > /dev/null
if test $? == 1
  then 
    echo MISSING J2 - install with sudo apt  install j2cli
    exit 1
fi

which jq > /dev/null
if test $? == 1
  then 
    echo MISSING JQ - install with sudo apt install jq
    exit 1
fi

which curl > /dev/null
if test $? == 1
  then 
    echo MISSING CURL - install with sudo apt install curl 
    exit 1
fi

# if credentials are stored in local file set them
if test -f credentials.env
  then
    source credentials.env
  else
    echo MISSING credentials.env
    exit 1
fi

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
        https://id.cisco.com/oauth2/default/v1/token | jq -r ".access_token")
    
        if test $token == null
          then
            echo -e "\nERROR: invalid credentials\n"
            exit 1
        fi

        platform="$1"
        version="$2"
    
        export platform=$platform
        export version=$version
    
        output=$(curl -s -k \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -X GET \
        -H "Accept: application/json" \
        -H "Authorization: Bearer $token" \
        https://apix.cisco.com/security/advisories/v2/OSType/$platform?version=$version) 
        
        errorcode=$(echo $output | jq ".errorCode")
        if test ! $errorcode == null
          then
            echo -e "\nERROR: $errorcode\n"
          elif test -z "$output"
            then
              echo -e "\nERROR: no output - check platform and version\n"
          else
            echo $output| jq | j2 -f json openvuln.j2 - > vuln-$platform-$version.md
            echo -e "\nCREATED FILE vuln-$platform-$version.md\n"
        fi 
      else 
        echo -e "\nERROR: Missing parameters platform and version"
        echo -e "\nUsage: $0 {ios|iosxe|nxos|aci|asa} {version}\n"
    fi
  else
    echo -e "\nERROR: Missing credentials CISCO_API_KEY and CISCO_CLIENT_SECRET\n"
fi

# unset credentials if imported from local file
if test -f credentials.env
  then
    unset CISCO_API_KEY
    unset CISCO_CLIENT_SECRET
fi