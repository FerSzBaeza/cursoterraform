variable "ip" {
default = "192.168.0.23/24"
}

output "salida" {
  value=var.ip
}