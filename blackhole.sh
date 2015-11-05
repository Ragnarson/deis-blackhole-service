#!/bin/bash
set -eo pipefail

/usr/bin/journalctl -D /var/log/journal _COMM=sshd -o json -f -n '100' | \
   grep --line-buffered 'Disconnecting: Too many authentication failures\|Failed password for' | \
   sed -u -e 's/^.*sshd@.*:22-//' -e 's/:.*$//' | \
   while read ip; do \
     if ! [[ $WHITELIST == *$ip* ]]; then \
       ip route add blackhole $ip 2>/dev/null || true ; \
       echo "$(date) - blocked $ip" ; \
     fi ; \
   done
