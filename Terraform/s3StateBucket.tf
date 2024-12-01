# Bucket para almacenar el archivo tfstate
resource "aws_s3_bucket" "s3_terraform" {
  bucket        = "githubactionsterraformstate"
  force_destroy = true
}
