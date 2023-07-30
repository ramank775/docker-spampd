#!/bin/sh

echo "Set bayes file permissions..."
mkdir -p /var/cache/spampd
chown -R spampd:spampd /var/cache/spampd/
chmod -R 0777 /var/cache/spampd/

echo "Updating SA filters..."
/usr/bin/sa-update --no-gpg

echo "Starting spampd..."
exec "$@"
