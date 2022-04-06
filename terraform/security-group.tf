# SubTask-3
####################################################################################################
# get self IP address
####################################################################################################

data "external" "myipaddr" {
  program = ["bash", "-c", "curl -s 'https://api.ipify.org?format=json'"]
}

output "local_public_ip" {
  value = data.external.myipaddr.result.ip
}

####################################################################################################
# bastion SG with ingress from self ip and all egress
####################################################################################################

resource "aws_security_group" "bastion-sg" {
  vpc_id      = aws_vpc.main.id
  name        = "bastion-sg"
  description = "security group for bastion"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.external.myipaddr.result.ip}/32"]
  }
}

####################################################################################################
# private SG with ingress from with VPC and all egress
####################################################################################################

resource "aws_security_group" "private-sg" {
  vpc_id      = aws_vpc.main.id
  name        = "private-sg"
  description = "security group for private"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.CIDR_BLOCK["vpc"]]
  }

  ingress {
    from_port   = 0
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.CIDR_BLOCK["vpc"]]
  }
}

####################################################################################################
# public web SG with ingress from self ip on 80 port and all egress
####################################################################################################

resource "aws_security_group" "public-web-sg" {
  vpc_id      = aws_vpc.main.id
  name        = "public-web-sg"
  description = "security group for public-web"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${data.external.myipaddr.result.ip}/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.CIDR_BLOCK["vpc"]]
  }

  ingress {
    from_port   = 0
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.CIDR_BLOCK["vpc"]]
  }
}