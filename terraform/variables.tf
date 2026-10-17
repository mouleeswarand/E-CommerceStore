variable "docker_username" {
  type        = string
  description = "The username for logging into your Docker Hub account"
}

variable "docker_password" {
  type        = string
  sensitive   = true
  description = "The password or Personal Access Token (PAT) for your Docker Hub account"
}
