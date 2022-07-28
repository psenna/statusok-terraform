variable "docker_host" {
  type    = string
  default = "unix:///var/run/docker.sock"
}

variable "influx_admin_user" {
  type    = string
  default = "root"
}

variable "influx_admin_password" {
  type    = string
  default = "root-password"
}

variable "influx_database" {
  type    = string
  default = "statusok"
}

variable "influx_reader_user" {
  type    = string
  default = "reader"
}

variable "influx_reader_password" {
  type    = string
  default = "reader_pass"
}

variable "influx_image" {
  type    = string
  default = "influxdb:1.8"
}

variable "influx_external_port" {
  type    = number
  default = 8086
}

variable "influx_internal_port" {
  type    = number
  default = 8086
}

variable "statusok_requests" {
  type = map(object({
    url          = string
    requestType  = string
    headers      = map(string)
    formParams   = map(string)
    checkEvery   = number
    responseTime = number
    responseCode = number
  }))
  default = {
    "google.com" = {
    checkEvery   = 30
    requestType  = "GET"
    headers      = {}
    formParams   = {}
    responseTime = 800
    url          = "https://google.com"
    responseCode = 200
    },
    "github.com" = {
      checkEvery   = 30
      requestType  = "GET"
      headers      = {}
      formParams   = {}
      responseTime = 800
      responseCode = 200
      url          = "https://github.com"
  }}
  description = "The set of requests objects for statusok watch"
}

variable "statusok_image" {
  type        = string
  default     = "psenna/statusok:v0.2.0"
  description = "The image used in statusok"
}

variable "grafana_image" {
  type    = string
  default = "grafana/grafana:main"
}

variable "grafana_admin_username" {
  type    = string
  default = "root"
}

variable "grafana_admin_password" {
  type    = string
  default = "root-password"
}

variable "grafana_external_port" {
  type    = number
  default = 3000
}