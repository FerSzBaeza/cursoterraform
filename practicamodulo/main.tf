provider "aws" {
  region = "eu-west-3"
}

module "ipserver" {
    source = "./modulos/modulo1"
    #ip = "Entrada"
}

output "salida" {
  value = module.ipserver.salida
}