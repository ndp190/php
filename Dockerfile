FROM go1com/php:7-nginx
ENV REACT_WORKER_SOCK=/tmp/react/reactphp.worker%s.sock
COPY rootfs/start-react.sh /start-react.sh
COPY rootfs/etc/nginx/sites-available/default.conf /etc/nginx/sites-available/default-react.conf
RUN mkdir -p /tmp/react \
    && chmod 755 -R /tmp/react
CMD ["/start-react.sh"]

