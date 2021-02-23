job "prometheus" {
  datacenters = ["dc1"]

  group "prometheus" {
    count = 1

    network {
        port "prometheus_ui" {
            static = 9090
        }
    }

    task "prometheus" {
      driver = "docker"

      config {
        image = "prom/prometheus:v2.18.1"

        args = [
          "--config.file=/etc/prometheus/config/prometheus.yml",
          "--storage.tsdb.path=/prometheus",
          "--web.console.libraries=/usr/share/prometheus/console_libraries",
          "--web.console.templates=/usr/share/prometheus/consoles",
        ]

        volumes = [
          "local/config:/etc/prometheus/config",
        ]
        ports = [
          "prometheus_ui"
        ]
      }

      template {
        data = <<EOH
---
global:
  scrape_interval:     1s
  evaluation_interval: 1s

scrape_configs:

  - job_name: nomad
    scrape_interval: 10s
    metrics_path: /v1/metrics
    params:
      format: ['prometheus']
EOH

        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/prometheus.yml"
      }

      resources {
        cpu    = 100
        memory = 256

        network {
          mbits = 10
        }
      }
    }
  }
}
