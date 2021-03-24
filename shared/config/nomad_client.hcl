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

plugin "raw_exec" {
  config = {
    enabled = true
  }
}

client {
  enabled    = true
  node_class = NODE_CLASS

  server_join {
    retry_join = ["RETRY_JOIN"]
  }

  options {
    "docker.privileged.enabled" = "true"
  }

  host_volume "cbr" {
    path = "/cbr"
    read_only = false
  }
}

