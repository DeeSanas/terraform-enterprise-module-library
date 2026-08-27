output "vpc_id" {
  description = "VPC identifier."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Map of public subnet IDs keyed by index."
  value       = { for key, subnet in aws_subnet.public : key => subnet.id }
}

output "private_subnet_ids" {
  description = "Map of private subnet IDs keyed by index."
  value       = { for key, subnet in aws_subnet.private : key => subnet.id }
}

output "public_route_table_id" {
  description = "Public route table identifier."
  value       = aws_route_table.public.id
}
