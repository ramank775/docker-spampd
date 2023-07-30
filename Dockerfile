FROM debian:12

ENV SPAMPD_RELAYHOST=smtp:10026
ENV SPAMPD_HOST=0.0.0.0:10025
ENV DEBIAN_FRONTEND noninteractive
ENV SPAMPD_VERSION=2.61
RUN apt-get update && \
    apt-get install -y --no-install-recommends spampd \
    pyzor \
    razor \
    rsyslog \
    supervisor \
    curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# HACK to update spampd version to latest
RUN curl --insecure https://raw.githubusercontent.com/mpaperno/spampd/${SPAMPD_VERSION}/spampd.pl -o /usr/sbin/spampd && \
    chmod 0755 /usr/sbin/spampd

VOLUME ["/var/cache/spampd"]

ENV DEBIAN_FRONTEND noninteractive
COPY files/spampd/spampd.conf /etc/default/spampd
COPY files/spamassassin/local.cf /etc/spamassassin/local.cf
COPY files/spamassassin/pyzor /etc/spamassassin/pyzor
COPY files/rsyslog/rsyslog.conf /etc/rsyslog.conf
COPY files/supervisor/supervisord.conf /etc/supervisor/supervisord.conf

EXPOSE 10025

## Add startup script.
COPY bin/run.sh /app/bin/run.sh
RUN chmod 0755 /app/bin/run.sh

ENTRYPOINT ["/app/bin/run.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
