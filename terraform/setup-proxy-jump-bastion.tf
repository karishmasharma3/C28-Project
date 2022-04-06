resource "local_file" "sshconfig-bastion" {
  filename = "./config/sshconfig-bastion"
  content  = <<EOF
Host appserver
  HostName ${aws_instance.app-instance.*.private_ip[0]}
  User ubuntu
  IdentityFile /tmp/${var.KEY_NAME}.pem
  Port 22

Host jenkinsserver
  HostName ${aws_instance.jenkins-instance.*.private_ip[0]}
  User ubuntu
  IdentityFile /tmp/${var.KEY_NAME}.pem
  Port 22

    EOF

  provisioner "remote-exec" {
    inline = [
    "sudo mkdir -p /home/ubuntu/.ssh"]
  }

  provisioner "file" {
    source      = "./config/sshconfig-bastion"
    destination = "/home/ubuntu/.ssh/config"
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
