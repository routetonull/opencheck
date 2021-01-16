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

Output is written to a file in $PWD named

    vuln-$platform-$version.md

Sample output:

---

# Security posture via Cisco PSIRT OpenVuln API

## Platform: aci
## Version:  14.2(1i)


| Advisory-ID | Impact | CVSS | CVE | Fixed with | First Published |
| ----------- | ------ | ---- | --- | ---------- | ----------------|
cisco-sa-20200226-fxos-nxos-cdp | Cisco FXOS and NX-OS Software Cisco Discovery Protocol Arbitrary Code Execution and Denial of Service Vulnerability | 8.8 | CVE-2020-3172 | 14.2(1j) | 2020-02-26T16:00:00
cisco-sa-20200205-fxnxos-iosxr-cdp-dos | Cisco FXOS, IOS XR, and NX-OS Software Cisco Discovery Protocol Denial of Service Vulnerability | 7.4 | CVE-2020-3120 | 14.2(1j) | 2020-02-05T16:00:00
cisco-sa-20200205-nxos-cdp-rce | Cisco NX-OS Software Cisco Discovery Protocol Remote Code Execution Vulnerability | 8.8 | CVE-2020-3119 | 14.2(1j) | 2020-02-05T16:00:00
