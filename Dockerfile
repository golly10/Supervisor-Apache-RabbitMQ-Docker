FROM php:7.2-apache

WORKDIR /
# In order to get rid of the prompt problem. Also works if we install tzdata in RUN statement
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends supervisor

# RabbitMQ part
ADD /bin/rabbitmq-start /usr/local/bin

RUN apt-get update && apt-get install -y wget gnupg

RUN \
    wget -O - "https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc" | apt-key add - && \
    echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y rabbitmq-server && \
    rm -rf /var/lib/apt/lists/* && \
    rabbitmq-plugins enable rabbitmq_management && \
    echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config && \
    chmod +x /usr/local/bin/rabbitmq-start

# Define environment variables.
ENV RABBITMQ_LOG_BASE /data/log
ENV RABBITMQ_MNESIA_BASE /data/mnesia
ENV RABBITMQ_USER user
ENV RABBITMQ_PASSWORD user

VOLUME [ "/data/log", "data/mnesia"]

COPY ./src /var/www/html/
COPY supervisord.conf /etc/supervisor/

EXPOSE 80
EXPOSE 9001
EXPOSE 5672
EXPOSE 15672

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]