resource "local_file" "inventory" {
  filename = "./ansible-playbooks/inventory.ini"
  content  = <<EOF
[all]
${aws_instance.jenkins-instance.*.private_ip[0]}
${aws_instance.app-instance.*.private_ip[0]}

[jenkins]
${aws_instance.jenkins-instance.*.private_ip[0]}

[app]
${aws_instance.app-instance.*.private_ip[0]}
    EOF

  provisioner "file" {
    source      = "./ansible-playbooks"
    destination = "/tmp/ansible-playbooks"
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

resource "null_resource" "ansible-run" {
  depends_on = [aws_instance.bastion-instance]
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${var.KEY_NAME}.pem")
    host        = aws_instance.bastion-instance.public_ip
    agent       = false
    timeout     = "1m"
  }

  provisioner "remote-exec" {
    inline = ["ansible-playbook --ssh-common-args='-o StrictHostKeyChecking=no' -u ubuntu --private-key /tmp/${var.KEY_NAME}.pem --become -i /tmp/ansible-playbooks/inventory.ini /tmp/ansible-playbooks/install-docker.yml"]
  }

  provisioner "remote-exec" {
    inline = ["ansible-playbook --ssh-common-args='-o StrictHostKeyChecking=no' -u ubuntu --private-key /tmp/${var.KEY_NAME}.pem --become -i /tmp/ansible-playbooks/inventory.ini /tmp/ansible-playbooks/install-jenkins.yml"]
  }
}
