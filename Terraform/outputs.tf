output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.vpc.id
}

output "subnet_id" {
  description = "ID de la subred pública"
  value       = aws_subnet.public_subnet_erik.id
}

output "ec2_instance_public_ip" {
  description = "Dirección IP pública de la instancia EC2"
  value       = aws_instance.ec2_instance.public_ip
}

output "ec2_instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.ec2_instance.id
}

output "bucket_name" {
  description = "Nombre del bucket S3"
  value       = aws_s3_bucket.s3.bucket
}

output "bucket_website_url" {
  description = "URL del sitio web alojado en el bucket S3"
  value       = aws_s3_bucket_website_configuration.s3_website.website_endpoint
}
