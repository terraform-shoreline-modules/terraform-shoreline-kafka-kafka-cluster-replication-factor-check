

#!/bin/bash



# Set variables

KAFKA_HOME=${PATH_TO_KAFKA_HOME}

TOPIC=${TOPIC_NAME}

REPLICATION_FACTOR=${REPLICATION_FACTOR}



# Increase replication factor of the topic

$KAFKA_HOME/bin/kafka-topics.sh --zookeeper $ZOOKEEPER_HOST:$ZOOKEEPER_PORT --alter --topic $TOPIC --partitions 1 --replication-factor $REPLICATION_FACTOR