####################################################################################################
# provision linux instance with aws cli
# Copy in the bash script on to linux box
# Change permissions on bash script and execute from ec2-user
# Login to the ec2-user with the aws key.
####################################################################################################
# Task 1 - SubTask-1

resource "aws_instance" "linux-instance" {
  ami                    = var.AMIS["linux"]
  instance_type          = "t2.micro"
  key_name               = var.KEY_NAME
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  subnet_id              = aws_subnet.main-public-1.id
  tags = {
    Name = "linux-instance"
  }

  provisioner "file" {
    source      = "./scripts/installawscli.sh"
    destination = "/tmp/installawscli.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/installawscli.sh",
      "sudo /tmp/installawscli.sh",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${var.KEY_NAME}.pem")
    host        = aws_instance.linux-instance.public_ip
    agent       = false
    timeout     = "1m"
  }
}

####################################################################################################
# provision bastion instance with provided AMI and region
####################################################################################################
# SubTask-3 and 4
resource "aws_instance" "bastion-instance" {
  ami                    = var.AMIS["bastion"]
  instance_type          = "t2.micro"
  key_name               = var.KEY_NAME
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  subnet_id              = aws_subnet.main-public-2.id

  tags = {
    Name = "bastion-instance"
  }

  provisioner "file" {
    source      = "${var.KEY_NAME}.pem"
    destination = "/tmp/${var.KEY_NAME}.pem"
  }

  # Task 2 - SubTask-1
  provisioner "file" {
    source      = "./scripts/installansible.sh"
    destination = "/tmp/installansible.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 /tmp/${var.KEY_NAME}.pem",
      "chmod +x /tmp/installansible.sh",
      "sudo /tmp/installansible.sh",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${var.KEY_NAME}.pem")
    host        = aws_instance.bastion-instance.public_ip
    agent       = false
    timeout     = "1m"
  }

}

####################################################################################################
# provision jenkins instance with provided AMI and region
####################################################################################################
# SubTask-3 and 4
resource "aws_instance" "jenkins-instance" {
  ami                    = var.AMIS["jenkins"]
  instance_type          = "t2.micro"
  key_name               = var.KEY_NAME
  vpc_security_group_ids = [aws_security_group.private-sg.id]
  subnet_id              = aws_subnet.main-private-2.id
  iam_instance_profile   = aws_iam_instance_profile.ecrprofile.name
  tags = {
    Name = "jenkins-instance"
  }

}

####################################################################################################
# provision app instance with provided AMI and region
####################################################################################################
# SubTask-3 and 4
resource "aws_instance" "app-instance" {
  ami                    = var.AMIS["app"]
  instance_type          = "t2.micro"
  key_name               = var.KEY_NAME
  vpc_security_group_ids = [aws_security_group.public-web-sg.id]
  subnet_id              = aws_subnet.main-private-1.id
  iam_instance_profile   = aws_iam_instance_profile.ecrprofile.name
  tags = {
    Name = "app-instance"
  }
}
