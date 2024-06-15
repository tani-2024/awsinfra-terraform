output "PublicIP" {
  value = aws_instance.public-instance.public_ip
}

output "PrivateIP" {
  value = aws_instance.public-instance.private_ip
}