job "autoscaler" {
  datacenters = ["dc1"]

  group "autoscaler" {
    count = 1

    task "autoscaler" {
      driver = "docker"

      config {
        image   = "hashicorp/nomad-autoscaler:0.2.1"
        command = "nomad-autoscaler"

        args = [
          "agent",
          "-config",
          "${NOMAD_TASK_DIR}/config.hcl",
          "-http-bind-address",
          "0.0.0.0",
          "-log-level",
          "debug",
          "-policy-dir",
          "${NOMAD_TASK_DIR}/policies/",
        ]
      }

      template {
        data = <<EOF
nomad {
  address = "http://{{env "attr.unique.network.ip-address" }}:4646"
}

apm "prometheus" {
  driver = "prometheus"
  config = {
    address = "http://{{ range service "prometheus" }}{{ .Address }}:{{ .Port }}{{ end }}"
  }
}

target "azure-vmss" {
  driver = "azure-vmss"
  config = {
    subscription_id = "14692f20-9428-451b-8298-102ed4e39c2a"
  }
}

strategy "target-value" {
  driver = "target-value"
}
EOF

        destination = "${NOMAD_TASK_DIR}/config.hcl"
      }

      template {
        data = <<EOF
scaling "cluster_policy" {
  enabled = true
  min     = 1
  max     = 2

  policy {

    cooldown            = "2m"
    evaluation_interval = "1m"

    check "cpu_allocated_percentage" {
      source = "prometheus"
      query  = "sum(nomad_client_allocated_cpu{node_class=\"hashistack\"}*100/(nomad_client_unallocated_cpu{node_class=\"hashistack\"}+nomad_client_allocated_cpu{node_class=\"hashistack\"}))/count(nomad_client_allocated_cpu{node_class=\"hashistack\"})"

      strategy "target-value" {
        target = 70
      }
    }

    check "mem_allocated_percentage" {
      source = "prometheus"
      query  = "sum(nomad_client_allocated_memory{node_class=\"hashistack\"}*100/(nomad_client_unallocated_memory{node_class=\"hashistack\"}+nomad_client_allocated_memory{node_class=\"hashistack\"}))/count(nomad_client_allocated_memory{node_class=\"hashistack\"})"

      strategy "target-value" {
        target = 70
      }
    }

    target "azure-vmss" {
      resource_group      = "hashistack-adapting-filly"
      vm_scale_set        = "clients"
      node_class          = "hashistack"
      node_drain_deadline = "5m"
    }
  }
}
EOF

        destination = "${NOMAD_TASK_DIR}/policies/hashistack.hcl"
      }

      resources {
        cpu    = 50
        memory = 128

        network {
          mbits = 10
          port "http" {}
        }
      }

      service {
        name = "autoscaler"
        port = "http"

        check {
          type     = "http"
          path     = "/v1/health"
          interval = "5s"
          timeout  = "2s"
        }
      }
    }
  }
}

