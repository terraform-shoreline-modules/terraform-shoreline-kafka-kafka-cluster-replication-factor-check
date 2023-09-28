bash

#!/bin/bash



# Set the Kafka configuration file path

KAFKA_CONFIG_FILE=${PATH_TO_KAFKA_CONFIG_FILE}



# Set the desired replication factor value

REPLICATION_FACTOR=${DESIRED_REPLICATION_FACTOR}



# Check the current replication factor value

CURRENT_REPLICATION_FACTOR=$(grep replication-factor $KAFKA_CONFIG_FILE | awk '{print $2}')



# Compare the current replication factor to the desired value

if [ $CURRENT_REPLICATION_FACTOR -eq $REPLICATION_FACTOR ]; then

  echo "Replication factor is already set to $REPLICATION_FACTOR."

else

  # Update the replication factor setting in the Kafka configuration file

  sed -i "s/replication-factor $CURRENT_REPLICATION_FACTOR/replication-factor $REPLICATION_FACTOR/g" $KAFKA_CONFIG_FILE

  

  # Restart the Kafka broker service to apply the new configuration

  systemctl restart kafka

  

  echo "Replication factor updated to $REPLICATION_FACTOR."

fi