data "archive_file" "pythonfile_zip" {
    type          = "zip"
    source_file   = "${path.module}/scripts/test.py"
    output_path   = "${path.module}/scripts/test.zip"
}

resource "aws_s3_object" "object_in_bucket" {
 bucket = "${aws_s3_bucket.mybucketforlambdafunctions.id}"
 key    = "test.zip"
 source = "${path.module}/scripts/test.zip"
}


resource "aws_s3_bucket" "mybucketforlambdafunctions" {
  bucket = "mybucketforlambdafunctions"
  force_destroy = true
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
