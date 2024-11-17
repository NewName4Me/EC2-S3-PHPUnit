# Bucket principal para el sitio web
resource "aws_s3_bucket" "s3" {
  bucket        = "107-bucket"
  force_destroy = true # Elimina el bucket y su contenido si es destruido
}

# Configuración de acceso público para el bucket
resource "aws_s3_bucket_public_access_block" "s3_public_block" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = false
  block_public_policy     = false 
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Política para permitir acceso público de lectura
resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.s3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.s3.arn}/*"
      }
    ]
  })
}

# Configuración del sitio web estático
resource "aws_s3_bucket_website_configuration" "s3_website" {
  bucket = aws_s3_bucket.s3.id

  index_document {
    suffix = "index.html"
  }
}

# Subida de archivos al bucket
data "local_file" "web_files" {
  for_each = fileset("../WebAreaS3", "**")      # Itera sobre todos los archivos en la carpeta `web`
  filename = "${abspath("../WebAreaS3")}/${each.key}" # Obtiene la ruta completa del archivo
}

resource "aws_s3_object" "s3_objects" {
  for_each = data.local_file.web_files
  bucket   = aws_s3_bucket.s3.id
  key      = each.key
  source   = each.value.filename
  content_type = lookup({
    "html" = "text/html"
    "css"  = "text/css"
    "js"   = "application/javascript"
  }, regex("^.*\\.([a-z]+)$", each.key)[0], "application/octet-stream")
}
