locals {
  grafana_env_vars = [
    "GF_SECURITY_ADMIN_USER=${var.grafana_admin_username}",
    "GF_SECURITY_ADMIN_PASSWORD=${var.grafana_admin_password}"
  ]
}

data "template_file" "grafana_datasource_connection" {
  template = "${file("${path.module}/config/grafana_connection.yml")}"
  vars = {
    influx_database = var.influx_database
    influx_reader_user = var.influx_reader_user
    influx_reader_password = var.influx_reader_password
    influx_url = "http://${local.influx_host}:${var.influx_internal_port}"
  }
}

data "template_file" "grafana_dashboards" {
  template = "${file("${path.module}/config/grafana_dashboard.json")}"
  for_each = var.statusok_requests
  vars = {
    request_url = each.value["url"]
    dashboard_title = each.key
  }
}


resource "docker_image" "grafana_image" {
  name = var.grafana_image
}

resource "docker_container" "grafana_container" {
  name  = "statusok-grafana"
  image = docker_image.grafana_image.latest
  env   = local.grafana_env_vars
  restart = "unless-stopped" 

  ports {
    internal = 3000
    external = var.grafana_external_port
    protocol = "tcp"
  }

  upload {
    file    = "/etc/grafana/provisioning/datasources/influx.yml"
    content = data.template_file.grafana_datasource_connection.rendered
  }

  upload {
    file    = "/etc/grafana/provisioning/dashboards/dashboard.yml"
    source = "${path.module}/config/grafana_dashboard.yml"
  }


  dynamic "upload" {
    for_each = data.template_file.grafana_dashboards
    content {
      file    = "/etc/grafana/provisioning/dashboards/${upload.key}.json"
      content = upload.value.rendered
    }
  }

  networks_advanced {
    name    = docker_network.statusok_network.id
    aliases = ["statusok-grafana"]
  }
}
