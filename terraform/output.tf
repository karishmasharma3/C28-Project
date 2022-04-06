####################################################################################################
# Output:
#     public IP of linux server
#     public IP of bastion server
#     public IP of jenkins server
#     public IP of app server
#     S3 bucket ID
#     VPC ID
#     Subnet IDs for public and private subnets 1 & 2
####################################################################################################

output "linux-instance-public-ip" {
  description = "The public IP of linux server"
  value       = aws_instance.linux-instance.*.public_ip[0]
}

output "bastion-instance-public-ip" {
  description = "The public IP of bastion server"
  value       = aws_instance.bastion-instance.*.public_ip[0]
}

output "bastion-instance-private-ip" {
  description = "The private IP of bastion server"
  value       = aws_instance.bastion-instance.*.private_ip[0]
}

output "jenkins-instance-public-ip" {
  description = "The public IP of jenkins server"
  value       = aws_instance.jenkins-instance.*.private_ip[0]
}

output "app-instance-private-ip" {
  description = "The private IP of app server"
  value       = aws_instance.app-instance.*.private_ip[0]
}

output "assignment-s3-bucket-name" {
  description = "S3 bucket ID"
  value       = aws_s3_bucket.assignement_s3_bucket.bucket_domain_name
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "private_subnet_1" {
  description = "The ID of the private subnet 1"
  value       = aws_subnet.main-private-1.id
}

output "private_subnet_2" {
  description = "The ID of the private subnet 2"
  value       = aws_subnet.main-private-2.id
}


output "public_subnet_1" {
  description = "The ID of the public subnet 1"
  value       = aws_subnet.main-public-1.id
}

output "public_subnet_2" {
  description = "The ID of the public subnet 2"
  value       = aws_subnet.main-public-2.id
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = concat(aws_lb.assignment.*.dns_name, [""])[0]
}

output "repository_name" {
  description = "Name of repository created"
  value       = aws_ecr_repository.assignment.name
}

output "repository_url" {
  description = "URL of first repository created"
  value       = aws_ecr_repository.assignment.repository_url
}