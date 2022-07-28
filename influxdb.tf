locals {
  influx_env_config = [
    "INFLUXDB_ADMIN_USER=${var.influx_admin_user}",
    "INFLUXDB_ADMIN_PASSWORD=${var.influx_admin_password}",
    "INFLUXDB_DB=${var.influx_database}",
    "INFLUXDB_READ_USER=${var.influx_reader_user}",
    "INFLUXDB_READ_USER_PASSWORD=${var.influx_reader_password}",
    "INFLUXDB_INIT_PORT=${var.influx_internal_port}"
  ]
  influx_host = one(docker_container.influx_container.network_data).ip_address
}

resource "docker_image" "influx_image" {
  name = var.influx_image
}

resource "docker_volume" "influx_data_volume" {
  name = "statusok-influx-data-volume"
}

resource "docker_container" "influx_container" {
  name  = "statusok-influxdb"
  image = docker_image.influx_image.latest
  env   = local.influx_env_config

  volumes {
    container_path = "/var/lib/influxdb"
    volume_name    = docker_volume.influx_data_volume.id
  }

  ports {
    internal = var.influx_internal_port
    external = var.influx_external_port
    protocol = "tcp"
  }

  networks_advanced {
    name    = docker_network.statusok_network.id
    aliases = ["statusok-influxdb"]
  }
}

