FROM haproxy:alpine
MAINTAINER flyceek <flyceek@gmail.com>

RUN set -x \
    && apk upgrade --update \
	&& apk add bash ca-certificates rsyslog \
	&& mkdir -p /etc/rsyslog.d/ \
	&& touch /var/log/haproxy.log \
        # here's the catch: by creating a soft-link that 
        # links /var/log/haproxy.log to /dev/stdout whatever 
        # rsyslogd writes to the file will endup being
        # propagated to the standard output of the container
	&& ln -sf /dev/stdout /var/log/haproxy.log

# Include our configurations (`./etc` contains the files that we'd
# need to have in the `/etc` of the container).
ADD ./etc/ /etc/

# Include our custom entrypoint that will the the job of lifting
# rsyslog alongside haproxy.
ADD ./entrypoint.sh /usr/local/bin/entrypoint

# Set our custom entrypoint as the image's default entrypoint
ENTRYPOINT [ "entrypoint" ]

# Make haproxy use the default configuration file
CMD [ "-f", "/etc/haproxy.cfg" ]