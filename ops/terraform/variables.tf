variable "hcp_project_id" {
  type        = string
  description = "HCP Packer project ID"
}

variable "hcp_bucket_name" {
  type        = string
  description = "HCP Packer bucket name"
}

variable "hcp_channel" {
  type        = string
  description = "HCP Packer channel (e.g., 'development')"
}


variable "db_password" {
  type        = string
  description = "admin password for the db instance"
  sensitive   = true
  default     = "postgres"

}
variable "db_username" {
  type        = string
  description = "admin username for the db instance"
  sensitive   = true
  default     = "postgres"
}

variable "db_database" {
  type        = string
  description = "database name"
  sensitive   = true
  default     = "jobsync_prod"
}
