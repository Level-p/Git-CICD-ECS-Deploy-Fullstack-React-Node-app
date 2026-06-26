
variable "MONGO_URI" {
  type      = string
  sensitive = true
}

variable "JWT_SECRET" {
  type      = string
  sensitive = true
}