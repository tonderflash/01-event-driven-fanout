resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "orders_bucket" {
  bucket = "event-driven-orders-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "Orders bucket"
    Environment = "Dev"
  }
}
