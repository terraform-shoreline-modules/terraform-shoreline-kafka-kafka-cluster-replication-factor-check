resource "shoreline_notebook" "kafka_cluster_replication_factor_check" {
  name       = "kafka_cluster_replication_factor_check"
  data       = file("${path.module}/data/kafka_cluster_replication_factor_check.json")
  depends_on = [shoreline_action.invoke_increase_replication_factor]
}

resource "shoreline_file" "increase_replication_factor" {
  name             = "increase_replication_factor"
  input_file       = "${path.module}/data/increase_replication_factor.sh"
  md5              = filemd5("${path.module}/data/increase_replication_factor.sh")
  description      = "Increase the replication factor of the topic so that it meets the minimum required number. This can be done using the Kafka command line tools or the Kafka API."
  destination_path = "/tmp/increase_replication_factor.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_increase_replication_factor" {
  name        = "invoke_increase_replication_factor"
  description = "Increase the replication factor of the topic so that it meets the minimum required number. This can be done using the Kafka command line tools or the Kafka API."
  command     = "`chmod +x /tmp/increase_replication_factor.sh && /tmp/increase_replication_factor.sh`"
  params      = ["ZOOKEEPER_HOST","TOPIC_NAME","REPLICATION_FACTOR","PATH_TO_KAFKA_HOME","ZOOKEEPER_PORT"]
  file_deps   = ["increase_replication_factor"]
  enabled     = true
  depends_on  = [shoreline_file.increase_replication_factor]
}

