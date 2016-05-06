# Credit for lots of this goes to: https://github.com/siomiz/PostgreSQL-S3
set -e # stop if any of these commands fail

echo "*** Starting run-backup.sh ***"

DATE=$(date +%Y%m%d_%H%M%S)
FILE="/tmp/$PREFIX-$DATE.sql"
GPG_FILE="/tmp/$PREFIX-$DATE.sql.gpg"
S3_URI="s3://$S3_BUCKET_NAME/$PREFIX-$DATE.sql.gpg"

echo "> Running pg_dumpall"
PGPASSWORD="$POSTGRES_ENV_POSTGRES_PASSWORD" pg_dumpall -h "$POSTGRES_PORT_5432_TCP_ADDR" -U "$POSTGRES_ENV_POSTGRES_USER" > $FILE

echo "> Downloading public key: ${GPG_PUBKEY_ID}"
gpg --keyserver pgp.mit.edu --recv-keys ${GPG_PUBKEY_ID}

echo "> Encrypting dump file using gpg"
gpg --always-trust -v -e -r ${GPG_PUBKEY_ID} -o $GPG_FILE $FILE

echo "> Zipping dump file"
gzip -9 $GPG_FILE

echo "> Uploading to S3"
AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" aws s3 cp "$GPG_FILE.gz" "$S3_URI"

# Clean up
rm $FILE
rm "$GPG_FILE.gz"

echo "Done."
