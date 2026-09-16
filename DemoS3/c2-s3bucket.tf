#resource block: random string
resource "random_string" "suffix" {
  length           = 6
  special          = false
  upper            = false
}



#resourrce block: s3 bucket
resource "aws_s3_bucket" "demo_bucket" {
  bucket = "devopzdemo-${random_string.suffix.id}"

  tags = {
    Name        = "My DevOps Demo bucket"
    Environment = "Production"
    Owner       = "Aayush"
  }
}