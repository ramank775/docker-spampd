FROM chambana/base:latest

MAINTAINER Josh King <jking@chambana.net>

ENV SPAMPD_RELAYHOST=smtp:10026

RUN apt-get -qq update && \
    apt-get install -y --no-install-recommends spampd \
                                               pyzor \
                                               razor && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

VOLUME ["/var/cache/spampd/.spamassassin"]

ADD files/spamassassin/local.cf /etc/spamassassin/local.cf

EXPOSE 10025

## Add startup script.
ADD bin/run.sh /app/bin/run.sh
RUN chmod 0755 /app/bin/run.sh

ENTRYPOINT ["/app/bin/run.sh"]
CMD ["/usr/bin/spampd", "--nodetach", "--user=spampd", "--group=spampd", "--host=0.0.0.0:10025", "--relayhost=${SPAMPD_RELAYHOST}", "--sef", "--tagall"]
