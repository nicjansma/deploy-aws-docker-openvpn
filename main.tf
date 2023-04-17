resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.0.0/24"
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "vpn" {
  name        = var.host_name
  description = "SSH + OpenVPN"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "udp"
    from_port   = 1194
    to_port     = 1194
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "vpn" {
  ami                         = var.base_image
  instance_type               = var.instance_type
  associate_public_ip_address = "true"
  vpc_security_group_ids      = ["${aws_security_group.vpn.id}"]
  key_name                    = var.ssh_key_name
  subnet_id                   = aws_subnet.main.id

  tags = {
    Name       = "${var.host_name}"
    created_by = "terraform"
  }

  provisioner "file" {
    source      = "./files/"
    destination = "/tmp"

    connection {
      host        = self.public_ip
      user        = var.ssh_user_name
      private_key = file(var.ssh_key)
    }
  }

  provisioner "remote-exec" {
    scripts = ["./scripts/configure_node.sh"]

    connection {
      host        = self.public_ip
      user        = var.ssh_user_name
      private_key = file(var.ssh_key)
    }
  }

  credit_specification {
    cpu_credits = "standard"
  }
}

output "address" {
  value = aws_instance.vpn.public_ip
}

resource "aws_route53_record" "vpn" {
  zone_id = var.host_route_53_zone_id
  name    = var.host_name
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.vpn.public_ip}"]
}
