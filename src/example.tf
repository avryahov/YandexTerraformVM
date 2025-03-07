data "yandex_compute_image" "container-optimized-image" {
  family = "container-optimized-image"
}

resource "yandex_compute_instance" "instance-based-on-coi" {
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.container-optimized-image.id
    }
  }
  network_interface {
    subnet_id = "e9bme03ge0a9oivegf4h"
    nat = true
  }
  resources {
    cores = 2
    memory = 2
    core_fraction = 20
  }
  metadata = {
    docker-container-declaration = file("${path.module}/declaration.yaml")
    user-data = file("${path.module}/cloud_config.yaml")
  }
}