output "web_public_dns" {
  value = aws_instance.web.public_dns
}

output "web_instance_id" {
  value = aws_instance.web.id
}