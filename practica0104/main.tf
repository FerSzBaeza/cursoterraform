provider "aws" {
  region = var.region_name
}

resource "aws_key_pair" "key" {
  key_name = "fsanzbae05"
  public_key = file(var.path_key)
}

resource "aws_security_group" "allow_ssh" {
  name = "allowss_fsanzbae"
  vpc_id = var.vpc_id
  ingress {
    description = "allow ssh"
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
    Name = "allow_ssh"
  }

}

resource "aws_security_group" "allow_http" {
    name        = "allowhttp_fsanzbae05"
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
  count = var.count_value
  ami = data.aws_ami.ubuntu.id
  availability_zone = var.availability_zone
  instance_type = var.instance_type
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_http.id
  ]
  /*
  user_data = templatefile(
    # path
    "${path.module}/userdata.sh",
    # variables para la plantilla
    # { port = 8080, ip_addrs = ["10.0.0.1", "10.0.0.2"] }
    {}
  )
  */
  key_name = aws_key_pair.key.key_name 
  tags = {Name = "fsanzbae05"}
}

resource "aws_ebs_volume" "web" {
  count = var.count_value
  availability_zone = var.availability_zone
  size              = 4
  type = "gp3"
  encrypted =   true
  tags = {
    Name = "fsanzbae05-web-ebs-${count.index}"
  }
}

resource "aws_volume_attachment" "web" {
  count = var.count_value
  device_name = "/dev/sdh"
  volume_id   = element(aws_ebs_volume.web.*.id, count.index)
  instance_id = element(aws_instance.vm.*.id, count.index)
}
