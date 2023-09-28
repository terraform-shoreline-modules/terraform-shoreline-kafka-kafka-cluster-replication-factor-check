
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kafka Cluster Replication Factor Check
---

This incident type typically involves checking the replication factor on a Kafka cluster to ensure that it is not configured to be too low. A low replication factor can lead to data loss, and it is important to verify that the system is configured correctly to prevent any issues. This may involve checking configuration settings, verifying that replication is working as expected, and making any necessary adjustments to ensure that the replication factor is set at an appropriate level.

### Parameters
```shell
export ZOOKEEPER_PORT="PLACEHOLDER"

export ZOOKEEPER_HOST="PLACEHOLDER"

export TOPIC_NAME="PLACEHOLDER"

export KAFKA_PORT="PLACEHOLDER"

export KAFKA_HOST="PLACEHOLDER"

export PARTITION_NUMBER="PLACEHOLDER"

export KAFKA_CONFIG_DIRECTORY="PLACEHOLDER"

export DESIRED_REPLICATION_FACTOR="PLACEHOLDER"

export PATH_TO_KAFKA_CONFIG_FILE="PLACEHOLDER"
```

## Debug

### List all topics in the Kafka cluster
```shell
kafka-topics.sh --list --zookeeper ${ZOOKEEPER_HOST}:${ZOOKEEPER_PORT}
```

### Describe a specific topic to view replication factor and other details
```shell
kafka-topics.sh --describe --zookeeper ${ZOOKEEPER_HOST}:${ZOOKEEPER_PORT} --topic ${TOPIC_NAME}
```

### View the status of all brokers in the cluster
```shell
kafka-broker-api-versions.sh --bootstrap-server ${KAFKA_HOST}:${KAFKA_PORT} --api-version-request
```

### Check the replication status of a specific topic partition
```shell
kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list ${KAFKA_HOST}:${KAFKA_PORT} --topic ${TOPIC_NAME} --partition ${PARTITION_NUMBER} --time -1 --offsets 1 | awk -F ":" '{sum += $3} END {print sum}'
```

### Check the minimum ISR (in-sync replicas) count for a specific topic partition
```shell
kafka-topics.sh --zookeeper ${ZOOKEEPER_HOST}:${ZOOKEEPER_PORT} --describe --topic ${TOPIC_NAME} | grep "Partition:${PARTITION_NUMBER}" | awk -F " " '{print $8}'
```

### Check the number of replicas for a specific topic partition
```shell
kafka-topics.sh --zookeeper ${ZOOKEEPER_HOST}:${ZOOKEEPER_PORT} --describe --topic ${TOPIC_NAME} | grep "Partition:${PARTITION_NUMBER}" | awk -F " " '{print $6}'
```

### Check the number of available brokers in the cluster
```shell
kafka-broker-api-versions.sh --bootstrap-server ${KAFKA_HOST}:${KAFKA_PORT} --api-version-request | grep "\[Broker\]"
```

### Check the Kafka configuration to see if replication factor is set correctly
```shell
grep -r "replication\.factor" ${KAFKA_CONFIG_DIRECTORY}
```

## Repair

### First, check the replication factor configuration setting on the Kafka cluster to verify that it is set at an appropriate level. This should be done using the Kafka command line tools or a web-based management interface, depending on how the cluster is configured.
```shell
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


```