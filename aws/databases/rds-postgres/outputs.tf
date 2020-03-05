output "params" {
  value = {
    endpoint = aws_db_instance.master.endpoint
    address  = aws_db_instance.master.address
    port     = aws_db_instance.master.port
    name     = aws_db_instance.master.name
    username = aws_db_instance.master.username
  }
}

output "secrets" {
  sensitive = true
  value = {
    password = random_string.password.result
  }
}
