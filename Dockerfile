FROM go1com/php:7-nginx
ENV REACT_WORKER_SOCK=/tmp/react/reactphp.worker%s.sock
COPY rootfs/start-react.sh /start-react.sh
COPY rootfs/etc/nginx/sites-available/default.conf /etc/nginx/sites-available/default-react.conf
RUN apt-get update \
    && apt-get install --no-install-recommends -y supervisor python-pip procps \
    && rm -rf /var/lib/apt/lists/* \
    && pip install superlance \
    && apt-get remove -y python-pip \
    && mkdir -p /tmp/react \
    && chmod 755 -R /tmp/react \
    && chown www-data -R /tmp/react
CMD ["/start-react.sh"]

