terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    docker = {
      source  = "registry.terraform.io/kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
  required_version = ">=1.8.4"
}
provider "yandex" {
  zone = "ru-central1-a"
}
provider "docker" {
  host = "ssh://yc-user@89.169.132.197:22"
}

resource "random_password" "root_password" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "random_password" "user_password" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "docker_container" "mysql" {
  name  = "mysql_${random_password.root_password.result}"
  image = "mysql:8"
  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.root_password.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.user_password.result}",
    "MYSQL_ROOT_HOST=%"
  ]
  ports {
    internal = 3306
    external = 3306
    ip       = "127.0.0.1"
  }
  restart = "always"
}
