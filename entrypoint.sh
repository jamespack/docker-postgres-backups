set -e # stop if any of these commands fail

# Write out runtime ENV vars so that cron can load them in.
env > /tmp/env.sh

echo "Starting cron..."
cron -f
