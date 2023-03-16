output "mybucketforlambdafunctions" {
  value = "${aws_s3_bucket.mybucketforlambdafunctions.id}"
}

output "object_in_bucket" {
  value = "${aws_s3_object.object_in_bucket.id}"
}

