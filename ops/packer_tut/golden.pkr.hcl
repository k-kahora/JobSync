
variable "base_ami_id" {
  type = string
}

source "amazon-ebs" "based_on_custom" {
  ami_name      = "jobsync-ami"
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami    = "${var.base_ami_id}"
  ssh_username  = "ubuntu"
}

build {
  name = "second-image"
  sources = ["source.amazon-ebs.based_on_custom"]

  # hcp_packer_registry {
  #   bucket_name = "jobsync-full-build"
  #   description = <<EOT
  #   An image for jobsync
  #   EOT
  #
  #   bucket_labels = {
  #     "hashicorp-learn" = "learn-packer-github-actions",
  #   }
  # }


  provisioner "shell" {
    scripts = [
      "./ops/packer_tut/install-latest.sh"
    ]
  }
  post-processor "manifest" {
    output     = "packer_manifest.json"
    strip_path = true
    custom_data = {
      version_fingerprint = packer.versionFingerprint
    }
  }
}
