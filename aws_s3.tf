resource "random_id" "id" {
  byte_length = 8
}

resource "aws_s3_bucket" "csye6225_s3_bucket" {
  bucket        = "csye6225-${random_id.id.hex}"
  force_destroy = true

  tags = {
    Environment = var.aws_profile
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "server_side_encryption_configuration" {
  bucket = aws_s3_bucket.csye6225_s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "make_s3_private" {
  bucket = aws_s3_bucket.csye6225_s3_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "standard_to_standard_ia" {
  bucket = aws_s3_bucket.csye6225_s3_bucket.id

  rule {
    id     = "standard-to-standard-ia"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.csye6225_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}