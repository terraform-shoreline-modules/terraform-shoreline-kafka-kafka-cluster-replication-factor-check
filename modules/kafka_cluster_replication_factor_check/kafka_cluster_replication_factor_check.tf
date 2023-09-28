resource "shoreline_notebook" "kafka_cluster_replication_factor_check" {
  name       = "kafka_cluster_replication_factor_check"
  data       = file("${path.module}/data/kafka_cluster_replication_factor_check.json")
  depends_on = [shoreline_action.invoke_kafka_replication_update]
}

resource "shoreline_file" "kafka_replication_update" {
  name             = "kafka_replication_update"
  input_file       = "${path.module}/data/kafka_replication_update.sh"
  md5              = filemd5("${path.module}/data/kafka_replication_update.sh")
  description      = "First, check the replication factor configuration setting on the Kafka cluster to verify that it is set at an appropriate level. This should be done using the Kafka command line tools or a web-based management interface, depending on how the cluster is configured."
  destination_path = "/agent/scripts/kafka_replication_update.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_kafka_replication_update" {
  name        = "invoke_kafka_replication_update"
  description = "First, check the replication factor configuration setting on the Kafka cluster to verify that it is set at an appropriate level. This should be done using the Kafka command line tools or a web-based management interface, depending on how the cluster is configured."
  command     = "`chmod +x /agent/scripts/kafka_replication_update.sh && /agent/scripts/kafka_replication_update.sh`"
  params      = ["PATH_TO_KAFKA_CONFIG_FILE","DESIRED_REPLICATION_FACTOR"]
  file_deps   = ["kafka_replication_update"]
  enabled     = true
  depends_on  = [shoreline_file.kafka_replication_update]
}

