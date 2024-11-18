output "webserver_public_ip" {
    description = "Public IP of the webserver1"
    value = aws_instance.webserver01.public_ip
}

output "webserver_private_ip" {
    description = "Private IP of the webserver2"
    value = aws_instance.webserver02.public_ip
}

output "rds_endpoint" {
    description = "RDS instance endoint"
    value = aws_db_instance.mysql.endpoint
}
