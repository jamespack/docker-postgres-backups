FROM postgres:9.4.5
MAINTAINER Siphon <hello@getsiphon.com>

USER root
RUN apt-get update
RUN apt-get install -q -y --force-yes cron

# Note that because cron does not seem to know about Docker's environment
# variables, we have to read them in from a file that we write out
# in entrypoint.sh at runtime.
#RUN echo "0 0,6,12,18 * * * env - \`cat /tmp/env.sh\` /bin/bash -c '(cd /code && sh run-backup.sh) >> /code/backups-cron.log 2>>\&1'" | crontab -
RUN echo "* * * * * env - \`cat /tmp/env.sh\` /bin/bash -c '(cd /code && sh run-backup.sh) >> /code/backups-cron.log 2>>\&1'" | crontab -

RUN mkdir -p /code
WORKDIR /code
ADD entrypoint.sh /code/entrypoint.sh
ADD run-backup.sh /code/run-backup.sh
RUN chmod +x /code/entrypoint.sh

ENTRYPOINT ["sh", "entrypoint.sh"]
CMD [""] # overrides the default from image we inherited from
