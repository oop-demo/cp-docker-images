FROM confluentinc/cp-kafka-connect:5.5.1

ENV CONNECT_PLUGIN_PATH="/usr/share/confluent-hub-components/confluentinc-kafka-connect-jdbc/"
ENV CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR=1
ENV CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR=1
ENV CONNECT_STATUS_STORAGE_REPLICATION_FACTOR=1
ARG CONFLUENT_JDBC_CONNECTOR_VERSION="5.5.1"
ARG CONNECT_PLUGIN_PATH="/usr/share/confluent-hub-components/confluentinc-kafka-connect-jdbc/"
ENV CONNECT_REST_PORT="8083"

RUN confluent-hub install confluentinc/kafka-connect-jdbc:${CONFLUENT_JDBC_CONNECTOR_VERSION} --no-prompt --verbose

ADD jars/* /usr/share/confluent-hub-components/confluentinc-kafka-connect-jdbc/lib/

# COPY include/etc/confluent/docker /etc/confluent/docker

ADD include/etc/confluent/docker/run /etc/confluent/docker/run
ADD include/etc/confluent/docker/distributed.sh /usr/local/bin/

RUN wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
    chmod +x jq-linux64 && \
    mv jq-linux64 /usr/local/bin/jq