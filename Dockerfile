FROM ubuntu:16.04
MAINTAINER Aset Madraimov <xiaset@gmail.com>
ARG KAFKA_VERSION=1.1.0
ARG SCALA_VERSION=2.12
ARG KAFKA_PACKAGE=kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" > \ 
    /etc/apt/sources.list.d/webupd8team-ubuntu-java-xenial.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
    apt-get update && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk*
RUN cd /opt && \
    wget http://www-us.apache.org/dist/kafka/$KAFKA_VERSION/$KAFKA_PACKAGE && \
    tar -xf $KAFKA_PACKAGE && rm -rf $KAFKA_PACKAGE && \
    ln -s kafka_$SCALA_VERSION-$KAFKA_VERSION kafka
COPY docker-entrypoint.sh /usr/local/bin/
ENV KAFKA_HEAP_OPTS "-Xms512m -Xmx1g"
ENV KAFKA_WHITELIST '".*"'
ENV KAFKA_NUMSTREAMS 1
ENV KAFKA_CONSUMER_BOOTSTRAP_SERVERS localhost:9092
ENV KAFKA_CONSUMER_GROUP_ID mirrormaker-01
ENV KAFKA_CONSUMER_CLIENT_ID 1
ENV KAFKA_CONSUMER_AUTO_OFFSET_RESET latest
ENV KAFKA_PRODUCER_BOOTSTRAP_SERVERS localhost:9092
ENV KAFKA_PRODUCER_CLIENT_ID mirrormaker-01
ENV KAFKA_PRODUCER_ACKS -1
ENV KAFKA_PRODUCER_RETRIES 2147483647
ENV KAFKA_PRODUCER_BATCH_SIZE 16384
ENTRYPOINT ["docker-entrypoint.sh"]
#CMD ["/opt/kafka/bin/kafka-mirror-maker.sh", "--consumer.config", "/opt/kafka/consumer.properties", "--producer.config", "/opt/kafka/producer.properties", "--whitelist", "echo ${KAFKA_WHITELIST}", "--num.streams", "echo ${KAFKA_NUMSTREAMS}"]
CMD /opt/kafka/bin/kafka-mirror-maker.sh --consumer.config /opt/kafka/consumer.properties --producer.config /opt/kafka/producer.properties --whitelist ${KAFKA_WHITELIST} --num.streams ${KAFKA_NUMSTREAMS}
