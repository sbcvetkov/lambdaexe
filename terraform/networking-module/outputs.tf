output "lambdaexe_subnet_1_cidr" {
  value = aws_subnet.lambdaexe_subnet_1.cidr_block
}

output "lambdaexe_subnet_2_cidr" {
  value = aws_subnet.lambdaexe_subnet_2.cidr_block
}

output "postgres_sg" {
  value = aws_security_group.postgres_sg.id
}

output "lambdaexe_db_subnet_group" {
  value = aws_db_subnet_group.lambdaexe_db_subnet_group.id
}