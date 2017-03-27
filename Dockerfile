FROM alpine:3.5
MAINTAINER Fco. Javier Delgado del Hoyo <frandelhoyo@gmail.com>

RUN apk add --update bash rsync openssh-client sshpass && rm -rf /var/cache/apk/*

ENV CRON_TIME="0 0 * * 7"
ENV EXCLUDE=*~

RUN mkdir /backup
VOLUME ["/root/.ssh", "/backup"]

COPY ["run.sh", "backup.sh", "/"]

CMD ["/run.sh"]
