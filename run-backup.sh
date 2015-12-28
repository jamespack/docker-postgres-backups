# Credit for lots of this goes to: https://github.com/siomiz/PostgreSQL-S3
set -e # stop if any of these commands fail

echo "*** Starting run-backup.sh ***"

DATE=$(date +%Y%m%d_%H%M%S)
FILE="/tmp/$PREFIX-$DATE.sql"
GPG_FILE="/tmp/$PREFIX-$DATE.sql.gpg"

echo "> Running pg_dumpall"
pg_dumpall -h "$POSTGRES_PORT_5432_TCP_ADDR" -U postgres > $FILE

echo "> Downloading public key: ${GPG_PUBKEY_ID}"
gpg --keyserver pgp.mit.edu --recv-keys ${GPG_PUBKEY_ID}

echo "> Encrypting dump file using gpg"
gpg --always-trust -v -e -r ${GPG_PUBKEY_ID} -o $GPG_FILE $FILE

# Clean up
#rm $FILE
#rm $GPG_FILE

echo "Done."
