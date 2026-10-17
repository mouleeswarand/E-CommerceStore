output "frontend_url" {
  value = "http://${aws_instance.ecommerce_server.public_ip}"
}