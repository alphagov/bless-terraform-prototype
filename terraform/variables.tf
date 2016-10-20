variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-1"
}

# See https://sites.google.com/a/digital.cabinet-office.gov.uk/gds-internal-it/news/aviationhouse-sourceipaddresses for details.
variable "cidr_admin_whitelist" {
  description = "CIDR ranges permitted to communicate with administrative endpoints"
  type        = "list"
  default     = [
    "80.194.77.90/32",
    "80.194.77.100/32",
    "85.133.67.244/32",
    "93.89.81.78/32"
  ]
}
