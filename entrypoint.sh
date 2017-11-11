#!/bin/bash
PROGRAM="stunnel"
set -eo pipefail
shopt -s nullglob

# if command starts with an option, prepend mysqld
if [ "${1:0:1}" = '-' ]; then
	set -- "$PROGRAM" "$@"
fi


: ACCEPT_STRING=${ACCEPT_STRING:-127.0.0.1:6379}

if [ -z ${CONNECT_STRING} ]; then
    echo "Must Specifiy CONNECT_STRING variable" 1>&2
    echo "In format <host>:<port>" 1>&2
    exit 1
fi

cat << EOF > /etc/stunnel/stunnel.conf
foreground = yes
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
verifyChain = yes
CApath = /etc/ssl/certs
output = /dev/stdout
syslog = no
ciphers = HIGH
client = yes
sslVersion = TLSv1.2
reset = no
EOF

exec "$@"