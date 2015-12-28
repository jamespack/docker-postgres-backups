# Credit for lots of this goes to: https://github.com/siomiz/PostgreSQL-S3
set -e # stop if any of these commands fail

: ${POSTGRES_PORT_5432_TCP_ADDR:?"--link to a PostgreSQL container is not set"}
: ${GPG_PUBKEY_ID:?"-e GPG_PUBKEY_ID is not set"}
: ${AWS_ACCESS_KEY_ID:?"-e AWS_ACCESS_KEY_ID is not set"}
: ${AWS_SECRET_ACCESS_KEY:?"-e AWS_SECRET_ACCESS_KEY is not set"}
: ${S3_BUCKET_NAME:?"-e S3_BUCKET_NAME is not set"}

echo "*** Starting run-backup.sh ***"



echo "Done."
