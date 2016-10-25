variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-1"
}
variable "ami" {
  default = "ami-c593deb6" # Ubuntu Xenial 16.04
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

variable "bless_function" {
  default = "bless_certificate"
}

variable "bless_user" {
  default = "engineer"
}

variable "ssh_ca_keys" {
  description = "SSH Certificate Authority keys deployed to all application servers"
  type        = "list"
  default     = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxeUxPYHHlLaPL9ysoDlnaeMnZuw9yZAmz8jSBqkPYkob1llp/F8C/aN37YaKtGDqBbsYHvOs9k41M28fVAt6qclHyLDocUkZjzF1gbAbPsvvQvtbnhCnmiyIvq/D4iiBThcXoaHXtcSrsV/IbRFctlTC2+H0O/UnltXOphpthmC37y3X2Rb7L0rlenAW6OYC+aO5/O7/zIClH3DbEWBtuH7WAUr4E7dniN67BdtTfQw1j2h5DkZb8haSAE17Ej1yycq0kmH7G9xfbflPoWTRTd3JSc2hjXWww0xUveYxwKvrS6TnVLWzsnonejmPbkk+Tl2xO2MJbnO0w+nlNGg2rFNiGOJ3SFa9BiS4ZRmQGsbMBVzL13bC6H3ipMxweSKtAzgmbEhSc8n/udxnYoZ79wNjO7WQ/Kzp/4AkcP8y12sLr52RnNkHiEKWsYDpHXqz4nBDoNgfMnMCFELjNp4hjuXAjRj00vdlaEEp6KEbdy4FOFzYDpJWw97eXDHzrCQ+kFeFKUSdfVU5UUPeP69BTWotwHfwWUpt/6Z2O+o0kCUv4QJGy7sPZ46hRbhKkkk8mvnqkazteb9mUFruFEQkuGl8KDnhQNGcNJWKS3TwagFRiHDPlEGZm2WXHCxWZTRmI1TFriTd8lOBptbps0XasxmFJeg+WmshGIF6YgxsDnw== SSH CA Key"
  ]
}
