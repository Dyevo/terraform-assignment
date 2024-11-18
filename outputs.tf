output "webserver1_public_ip" {
    description = "Public IP of the webserver1"
    value = aws_instance.Webserver01.public_ip
}

output "webserver2_public_ip" {
    description = "Private IP of the webserver2"
    value = aws_instance.Webserver02.public_ip
}

output "rds_endpoint" {
    description = "RDS instance endoint"
    value = aws_db_instance.mysql.endpoint
}
