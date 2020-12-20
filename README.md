# OPENCHECK

Get [Cisco PSIRT OpenVuln](https://developer.cisco.com/psirt/) for a provided platform/version and renders a markdown report.

*Inspired by [https://github.com/NWMichl/openvuln](https://github.com/NWMichl/openvuln)*

Requirements:
- CISCO_API_KEY and CISCO_CLIENT_SECRET to access [PSIRT API](https://developer.cisco.com/psirt/)
- [curl](https://curl.se/)
- [jq](https://stedolan.github.io/jq/)
- [j2cli](https://github.com/kolypto/j2cli)

Env vars:

    export CISCO_API_KEY=myciscoapikey
    export CISCO_CLIENT_SECRET=mycisccolientsecret

Usage:

    ./opencheck.sh <platform> <version>

Example:

    ./opencheck.sh aci "14.2(1i)"

Output goest to a file in $PWD named

    vuln-$platform-$version.md
