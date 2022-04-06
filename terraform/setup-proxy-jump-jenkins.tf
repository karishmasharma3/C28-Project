resource "local_file" "sshconfig-jenkins" {
  filename = "./config/sshconfig-jenkins"
  content  = <<EOF
Host appserver
  HostName ${aws_instance.app-instance.*.private_ip[0]}
  User ubuntu
  IdentityFile /tmp/${var.KEY_NAME}.pem
  Port 22

    EOF

  provisioner "remote-exec" {
    inline = [
    "mkdir -p /tmp/jenkins-config"]
  }

  provisioner "file" {
    source      = "./config/sshconfig-jenkins"
    destination = "/tmp/jenkins-config/config"
  }

  provisioner "remote-exec" {
    inline = [
      "ssh jenkinsserver mkdir -p /home/ubuntu/.ssh",
      "scp /tmp/jenkins-config/config jenkinsserver:/home/ubuntu/.ssh/",
      "scp /tmp/${var.KEY_NAME}.pem jenkinsserver:/tmp/",
    "echo '${aws_instance.app-instance.*.private_ip[0]} appserver' | sudo tee -a /etc/hosts"]
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
