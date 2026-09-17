output "vpc_id" {
  value       = aws_vpc.ecom_vpc.id
  description = "The ID of the created VPC"
}

output "public_subnet_ids" {
  value       = [for s in aws_subnet.ecom_public_subnet : s.id]
  description = "List of public subnet IDs"
}

output "private_subnet_ids" {
  value       = [for s in aws_subnet.ecom_private_subnet : s.id]
  description = "List of private subnet IDs"
}

output "public_subnet_map" {
  value       = { for az, subnet in aws_subnet.ecom_public_subnet : az => subnet.id }
  description = "Map of AZ to Public Subnet ID"
}