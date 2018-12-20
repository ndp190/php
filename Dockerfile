FROM go1com/php:7-nginx
ENV REACT_WORKER_SOCK=/tmp/react/reactphp.worker%s.sock
RUN mkdir -p /tmp/react
COPY rootfs/start-react.sh /start-react.sh
COPY rootfs/etc/nginx/sites-available/default.conf /etc/nginx/sites-available/default.conf
CMD ["/start-react.sh"]
