data_dir  = "/opt/nomad/data"
bind_addr = "0.0.0.0"
region     = "REGION"
datacenter = "DATACENTER"

log_level = "DEBUG"

telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
  prometheus_metrics         = true
}

client {
  enabled    = true
  node_class = NODE_CLASS

  server_join {
    retry_join = ["RETRY_JOIN"]
  }

  options {
    "driver.raw_exec.enable"    = "1"
    "docker.privileged.enabled" = "true"
  }
}

