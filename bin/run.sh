#!/bin/bash -

. /app/lib/common.sh

MSG "Set bayes file permissions..."
chown -R spampd:spampd /var/cache/spampd/.spamassassin
chmod -R 0777 /var/cache/spampd/.spamassassin

MSG "Configuring Razor & Pyzor..."
su - spampd -c 'razor-admin -create'
su - spampd -c 'razor-admin -register'
su - spampd -c 'pyzor discover'

MSG "Updating SA filters..."
/usr/bin/sa-update

MSG "Starting spampd..."
exec "$@"
