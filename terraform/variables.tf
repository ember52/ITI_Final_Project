variable "mysql_host" {
  description = "The MySQL host"
  type        = string
  default     = "mysql" # Default to the service name
}

variable "mysql_username" {
  description = "The MySQL username"
  type        = string
  default     = "root"
}

variable "mysql_password" {
  description = "The MySQL password"
  type        = string
  sensitive   = true
}

variable "mysql_database" {
  description = "The MySQL database name"
  type        = string
}
