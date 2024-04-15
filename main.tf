resource "random_integer" "random_number" {
  min = 1
  max = 100
}

output "random_number_output" {
  value = random_integer.random_number.result
}

resource "random_string" "random_filename" {
  length  = 10
  special = false  # Optional: Erlaubt spezielle Zeichen, wie z.B. !@#$%^&*()
}

output "random_filename_output" {
  value = random_string.random_filename.result
}

provider "tls" {}

resource "tls_private_key" "example_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "example_cert" {
  key_algorithm   = tls_private_key.example_key.algorithm
  private_key_pem = tls_private_key.example_key.private_key_pem
  subject {
    common_name = "example.com"
  }
  validity_period_hours = 8760 # Gültigkeit für ein Jahr
}

output "self_signed_cert" {
  value = tls_self_signed_cert.example_cert.cert_pem
}

output "private_key" {
  value = tls_private_key.example_key.private_key_pem
}

data "template_file" "config_template" {
  template = file("config_template.json")

  vars = {
    user     = "your_username"
    password = "your_password"
  }
}

resource "local_file" "config_file" {
  content  = data.template_file.config_template.rendered
  filename = "config.json"
}

provider "archive" {}

data "archive_file" "my_archive" {
  type        = "zip"
  source_dir  = "${path.module}/data/files"
  output_path = "${path.module}/data/my_archive.zip"
}

provider "http" {}

data "http" "chuck_norris_joke" {
  url = "https://api.chucknorris.io/jokes/random"
}

resource "local_file" "chuck_norris_joke_file" {
  content  = data.http.chuck_norris_joke.body
  filename = "chuck_norris_joke.txt"
}

variable "create_file" {
  type    = bool
  default = false
}

resource "local_file" "conditional_file" {
  count = var.create_file ? 1 : 0

  content  = "Dies ist eine bedingte Datei."
  filename = "conditional_file.txt"
}

resource "null_resource" "run_script" {
  provisioner "local-exec" {
    command = "${path.module}/script.sh"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "random_password" "secure_password" {
  length           = 12
  special          = true
  override_special = "_%@"
}

output "random_password_output" {
  value = random_password.secure_password.result
}

provider "random" {}

variable "subnet_count" {
  type    = number
  default = 5
}

resource "random_integer" "subnet_count_random" {
  min     = 1
  max     = var.subnet_count
  count   = 1
}

resource "random_cidr" "subnets" {
  count = random_integer.subnet_count_random.result

  base_cidr_block = "10.0.0.0/16"
  prefix_length   = 24
}

resource "local_file" "subnet_info" {
  filename = "subnet_info.txt"
  content  = join("\n", random_cidr.subnets.*.cidr_block)
}

provider "random" {}

resource "random_integer" "red" {
  min = 0
  max = 255
}

resource "random_integer" "green" {
  min = 0
  max = 255
}

resource "random_integer" "blue" {
  min = 0
  max = 255
}

resource "local_file" "color_scheme" {
  filename = "color_scheme.txt"
  content  = <<-EOF
    # Farbschema generiert durch Terraform
    Red:   ${format("%02x", random_integer.red.result)}
    Green: ${format("%02x", random_integer.green.result)}
    Blue:  ${format("%02x", random_integer.blue.result)}
  EOF
}
