#!/bin/bash -e

# echo -e "${ADMIN_PASSWORD}\n${ADMIN_PASSWORD}" | passwd admin

if [ ! -f /etc/cups/cupsd.conf ]; then
  cp -rpn /etc/cups-bak/* /etc/cups/
fi

exec "$@"
