# Credit for lots of this goes to: https://github.com/siomiz/PostgreSQL-S3
set -e # stop if any of these commands fail

echo "*** Starting run-backup.sh ***"

DATE=$(date +%Y%m%d_%H%M%S)
FILE="/tmp/$PREFIX-$DATE.sql"
GPG_FILE="/tmp/$PREFIX-$DATE.sql.gpg"
S3_URI="s3://$S3_BUCKET_NAME/$PREFIX-$DATE.sql.gpg.gz"

echo "> Running pg_dump"
PGPASSWORD="$POSTGRES_PASSWORD" pg_dumpall -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" > $FILE

echo "> import public key from /var/gpgkeys/"
gpg --import ${GPG_PUBKEY_PATH}

echo "> Encrypting dump file using gpg"
KEYID=`gpg --batch --with-colons ${GPG_PUBKEY_PATH} | head -n1 | cut -d: -f5`
gpg --always-trust -v -e -r ${KEYID} -o $GPG_FILE $FILE

echo "> Zipping dump file"
gzip -9 $GPG_FILE

echo "> Uploading to S3"
AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" aws s3 cp "$GPG_FILE.gz" "$S3_URI" --endpoint-url "$S3_ENDPOINT" --acl bucket-owner-full-control

# Clean up
rm $FILE
rm "$GPG_FILE.gz"

echo "Done."
