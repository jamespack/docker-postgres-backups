set -e # stop if any of these commands fail

: ${POSTGRES_PORT_5432_TCP_ADDR:?"--link to a PostgreSQL container is not set"}
: ${GPG_PUBKEY_ID:?"-e GPG_PUBKEY_ID is not set"}
: ${AWS_ACCESS_KEY_ID:?"-e AWS_ACCESS_KEY_ID is not set"}
: ${AWS_SECRET_ACCESS_KEY:?"-e AWS_SECRET_ACCESS_KEY is not set"}
: ${S3_BUCKET_NAME:?"-e S3_BUCKET_NAME is not set"}
: ${PREFIX:?"-e PREFIX is not set"}
: ${DUMP_OPTIONS:?""}

echo "Starting cron daemon..."
cron -f
