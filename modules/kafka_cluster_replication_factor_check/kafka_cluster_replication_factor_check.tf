resource "shoreline_notebook" "kafka_cluster_replication_factor_check" {
  name       = "kafka_cluster_replication_factor_check"
  data       = file("${path.module}/data/kafka_cluster_replication_factor_check.json")
  depends_on = [shoreline_action.invoke_change_kafka_replication_factor]
}

resource "shoreline_file" "change_kafka_replication_factor" {
  name             = "change_kafka_replication_factor"
  input_file       = "${path.module}/data/change_kafka_replication_factor.sh"
  md5              = filemd5("${path.module}/data/change_kafka_replication_factor.sh")
  description      = "First, check the replication factor configuration setting on the Kafka cluster to verify that it is set at an appropriate level. This should be done using the Kafka command line tools or a web-based management interface, depending on how the cluster is configured."
  destination_path = "/agent/scripts/change_kafka_replication_factor.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_change_kafka_replication_factor" {
  name        = "invoke_change_kafka_replication_factor"
  description = "First, check the replication factor configuration setting on the Kafka cluster to verify that it is set at an appropriate level. This should be done using the Kafka command line tools or a web-based management interface, depending on how the cluster is configured."
  command     = "`chmod +x /agent/scripts/change_kafka_replication_factor.sh && /agent/scripts/change_kafka_replication_factor.sh`"
  params      = ["PATH_TO_KAFKA_CONFIG_FILE","DESIRED_REPLICATION_FACTOR"]
  file_deps   = ["change_kafka_replication_factor"]
  enabled     = true
  depends_on  = [shoreline_file.change_kafka_replication_factor]
}

