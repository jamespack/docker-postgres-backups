FROM postgres:13.2
MAINTAINER Dominique Burnand <youwillfind@me.com>

RUN apt-get update
RUN apt-get install -q -y --force-yes \
  cron \
  gnupg \
  python-pip \
  gzip

# AWS Command Line Interface
RUN pip install awscli==1.18.72

# Do backup all 5 minutes
RUN echo "5,10,15,20,25,30,35,40,45,50,55 * * * * sh /code/run-backup.sh >> /code/backups-cron.log" | crontab -
# Do backup every hour
RUN (crontab -l ; echo "0 * * * * sh /code/run-backup.sh hourly >> /code/backups-cron.log")| crontab -
# Do daily backup at midnight
RUN (crontab -l ; echo "7 0 * * * sh /code/run-backup.sh daily >> /code/backups-cron.log")| crontab -

RUN mkdir -p /code
WORKDIR /code
ADD entrypoint.sh /code/entrypoint.sh
ADD run-backup.sh /code/run-backup.sh
ADD cleanup.sh /code/cleanup.sh
RUN chmod +x /code/entrypoint.sh
RUN chmod +x /code/cleanup.sh

# Create non root user
RUN adduser --uid 888 app
RUN chown -R 888 /code

# Cron runable by custom user
RUN chmod u+s /usr/sbin/cron

# Drop to non-root user
USER 888

ENTRYPOINT ["sh", "entrypoint.sh"]
CMD [""]
