####################################################################################################
# Provision S3 bucket
####################################################################################################
# SubTask-1
resource "aws_s3_bucket" "assignement_s3_bucket" {
  bucket_prefix = "assignement-s3-${random_string.random.result}"
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}