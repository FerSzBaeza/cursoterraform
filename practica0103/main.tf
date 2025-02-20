provider "aws" {
  region = var.region_name
}

resource "aws_key_pair" "clave" {
  key_name = "fsanzbae05"
  public_key = file(var.ruta_key)
}

resource "aws_ebs_volume" "ebs" {
  availability_zone = var.availability_zone
  size = 4
  type = "gp3"
  tags = {
    Name = "fsanzbae05"
  }
}

resource "aws_security_group" "ssh" {
  name = "allow_ssh_fsanzbae05"
  description = "Permite la conexion ssh"
  vpc_id = var.vpc_id

  ingress {
    description = "ssh from VPC"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_fsanzbae05"
  }

}

resource "aws_security_group" "allow_http" {
    name        = "allow_http-fsanzbae05"
    description = "Allow http inbound traffic"
    vpc_id      = var.vpc_id

    ingress {
      description = "http from VPC"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "allow_http"
    }
}

resource "aws_instance" "vm" {
  ami = data.aws_ami.ubuntu.id
  availability_zone = var.availability_zone
  instance_type = var.instance_type
  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    aws_security_group.allow_http.id
  ]
  user_data = templatefile(
    # path
    "${path.module}/userdata.sh",
    # variables para la plantilla
    # { port = 8080, ip_addrs = ["10.0.0.1", "10.0.0.2"] }
    {}
  )
  key_name = aws_key_pair.clave.key_name
  tags = {
    Name = "fsanzbae05"
  }
}

resource "aws_eip" "eip" {
  instance = aws_instance.vm.id
  domain = "vpc"
  tags = {
    Name = "fsanzbae05"
  } 
}

resource "aws_volume_attachment" "web" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs.id
  instance_id = aws_instance.vm.id
}