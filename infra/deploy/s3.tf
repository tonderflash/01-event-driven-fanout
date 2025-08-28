resource "aws_s3_bucket" "orders_bucket" {
  bucket = "orders"

  tags = {
    Name        = "Orders bucket"
    Environment = "Dev"
  }
}
