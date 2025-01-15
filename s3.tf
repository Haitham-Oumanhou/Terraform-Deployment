resource "aws_s3_bucket" "react_website" {
  bucket = "todo-website"
}

resource "aws_s3_bucket_ownership_controls" "ownership_control" {
  bucket = aws_s3_bucket.react_website.bucket

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.react_website.bucket

  block_public_acls          = true
  ignore_public_acls         = true
  block_public_policy        = false
  restrict_public_buckets    = false
}

resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket = aws_s3_bucket.react_website.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "s3:GetObject"
        Effect    = "Allow"
        Resource  = "arn:aws:s3:::${aws_s3_bucket.react_website.bucket}/*"
        Principal = "*"
      },
    ]
  })
}

resource "aws_s3_object" "react_files" {
  for_each = fileset("C:/Users/ASUS/Desktop/ServerlessApp/frontend/build", "**")  
  bucket = aws_s3_bucket.react_website.bucket
  key    = each.value
  source = "C:/Users/ASUS/Desktop/ServerlessApp/frontend/build/${each.value}"

  content_type = lookup({
    ".html" = "text/html",
    ".css"  = "text/css",
    ".js"   = "application/javascript",
    ".json" = "application/json",
    ".jpg"  = "image/jpeg",
    ".jpeg" = "image/jpeg",
    ".png"  = "image/png",
    ".gif"  = "image/gif",
    ".svg"  = "image/svg+xml",
    ".ico"  = "image/x-icon"
  }, lower(regex("(\\.[a-z]+)$", each.value)[0]), "application/octet-stream")
}

resource "aws_s3_bucket_website_configuration" "react_website_config" {
  bucket = aws_s3_bucket.react_website.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}