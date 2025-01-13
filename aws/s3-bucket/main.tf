data "aws_canonical_user_id" "current" {}

locals {
  bucket_name           = var.bucket_name
  enable_logging        = var.enable_logging
  target_bucket         = var.logging_target_bucket
  target_prefix         = var.logging_target_bucket_prefix
  expected_bucket_owner = var.logging_expected_bucket_owner
  tags = merge(var.additional_tags, {
    Name = var.bucket_name
  })
}

resource "aws_s3_bucket" "bucket" {
  bucket = local.bucket_name

  force_destroy = true

  tags = local.tags
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership_controls" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.bucket_ownership_controls]
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "s3_logging" {
  count  = local.enable_logging ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  expected_bucket_owner = local.expected_bucket_owner
  target_bucket         = local.target_bucket
  target_prefix         = local.target_prefix
}