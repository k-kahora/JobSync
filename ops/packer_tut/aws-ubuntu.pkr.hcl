
source "amazon-ebs" "based_on_custom" {
  ami_name      = "my-second-custom-ami"
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami    = local.base_ami_id
  ssh_username  = "ubuntu"
}

build {
  name = "second-image"
  sources = ["source.amazon-ebs.based_on_custom"]

  provisioner "shell" {
    inline = [
      "echo 'This is the second layer image'",
      "sudo apt install -y htop"
    ]
  }
}
packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "learn-packer-linux-aws"
  instance_type = "t2.micro"
  region        = "us-west-2"
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
  name = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {
    inline = [
      "sudo apt update",
      "sudo apt install -y software-properties-common",
      "sudo add-apt-repository universe",
      "sudo add-apt-repository multiverse",
      "sudo apt update"
    ]
  }

  provisioner "shell" {
    script = "./user-data.sh"
  }
  
  post-processor "manifest" {
    output = "manifest.json"
  }
}
