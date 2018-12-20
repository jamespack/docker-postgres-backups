docker-postgres-backups
=======================

Uses `pg_dump` to dump a postgresDB, encrypts with PGP and uploads to S3.
It does also cleanup old backups.

#### Schedules
It does a backup every
- 5 Minutes to the folder ./latest 
- hour to the folder ./hourly
- day to the folder ./daily

#### Clenup
It removes old backups on s3 in the following way
- latest-backups: older than 3 hours
- hourly-backups: older than a day
- daily-backups: older than 3 months

#### Encryption
The public-key for gpg should be placed inside a directory and mounted as a 
volume into the container.
Example docker-compose declaration
----------------------------------

Paste this into your `compose.yaml` file.

```yaml
postgres_backups:
  image: jegger/postgres-backups:latest
  environment:
    AWS_ACCESS_KEY_ID: my-aws-key
    AWS_SECRET_ACCESS_KEY: my-aws-secret
    S3_BUCKET_NAME: my-backups
    S3_ENDPOINT: https://sos-ch-dk-2.exo.io  # Allows non Amazon endpoints
    PREFIX: postgres-backup # S3 key prefix to save with
    POSTGRES_HOST: my-postgres-service-name
    POSTGRES_PORT: 4321  # Port to postgres
    POSTGRES_PASSWORD: postgres
    POSTGRES_USER: postgres
    POSTGRES_DB: postgres
    BUCKET_PATH: postgres-backup
    GPG_PUBKEY_PATH: /var/gpgkeys/pub.key # path to PGP public key
  volumes:
    /local/path/to/key:/var/gpgkeys
```

Building
--------

```
docker build -t jegger/postgres-backups:latest .
docker login
docker push jegger/postgres-backups:latest
```
