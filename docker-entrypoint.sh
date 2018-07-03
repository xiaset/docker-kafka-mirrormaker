#!/bin/bash
cat <<EOT >> /opt/kafka/consumer.properties
bootstrap.servers=$KAFKA_CONSUMER_BOOTSTRAP_SERVERS
group.id=$KAFKA_CONSUMER_GROUP_ID
client.id=$KAFKA_CONSUMER_CLIENT_ID
auto.offset.reset=$KAFKA_CONSUMER_AUTO_OFFSET_RESET
enable.auto.commit=false
partition.assignment.strategy=org.apache.kafka.clients.consumer.RoundRobinAssignor
EOT

cat <<EOT >> /opt/kafka/producer.properties
bootstrap.servers=$KAFKA_PRODUCER_BOOTSTRAP_SERVERS
client.id=$KAFKA_PRODUCER_CLIENT_ID
acks=$KAFKA_PRODUCER_ACKS
retries=$KAFKA_PRODUCER_RETRIES
batch.size=$KAFKA_PRODUCER_BATCH_SIZE
max.in.flight.requests.per.connection=1
EOT

exec "$@"
#/opt/kafka/bin/kafka-mirror-maker.sh --consumer.config /opt/kafka/consumer.properties --producer.config /opt/kafka/producer.properties --whitelist \"${KAFKA_WHITELIST}\" --num.streams ${KAFKA_NUMSTREAMS}
