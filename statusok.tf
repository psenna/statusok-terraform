locals {
  statusok_configuration = <<EOT
    {
	"database":{
        "influxDb":{
            "host":"${local.influx_host}",
            "port":${var.influx_internal_port},
            "databaseName":"${var.influx_database}",
            "username":"${var.influx_admin_user}",
            "password":"${var.influx_admin_password}"
        }
    },
	"requests": ${jsonencode(values(var.statusok_requests))}
}
  EOT
}

resource "docker_image" "statusok_image" {
  name = var.statusok_image
}

resource "docker_container" "statusok_container" {
  name  = "statusok-statusok"
  image = docker_image.statusok_image.latest
  restart = "unless-stopped" 

  upload {
    file    = "/config/config.json"
    content = local.statusok_configuration
  }

  networks_advanced {
    name    = docker_network.statusok_network.id
    aliases = ["statusok-statusok"]
  }
}