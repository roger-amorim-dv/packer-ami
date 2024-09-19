packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-instance" "alpine" {
  ami_name      = "${var.ami_name}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-east-2"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name    = "virtual-machine-builder-packer"
  sources = [
    "source.amazon-instance.alpine"
  ]

  provisioner "shell" {
    script = "scripts/setup-custom-alpine-vm-builder.sh"
  }
}

variable "ami_name" {
  description = "The name of the AMI to create"
}