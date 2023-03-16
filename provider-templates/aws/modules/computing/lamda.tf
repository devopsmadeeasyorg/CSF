resource "aws_lambda_function" "test_lambda" {
  s3_bucket = "${var.mybucketforlambdafunctions}"
  s3_key = "${var.object_in_bucket}"
  function_name    = "test_lambda"
  role             = "${aws_iam_role.iam_for_lambda_tf.arn}"
  handler          = "index.handler"
  runtime          = "python3.8"
  /* layers = [aws_lambda_layer_version.mylambda_layer.arn] */
}

resource "aws_iam_role" "iam_for_lambda_tf" {
  name = "iam_for_lambda_tf"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#The below commands need to execute if you want to create AWS Lambda layers
#pip install pymysql -t python --upgrade --no-user
#mv python modules/computing/scripts
/* data "archive_file" "lambdalayer_zip" {
    type          = "zip"
    source_dir   = "${path.module}/scripts/python"
    output_path   = "${path.module}/scripts/lamda_layer.zip"
}

resource "aws_lambda_layer_version" "mylambda_layer" {
  filename   = "${path.module}/scripts/lamda_layer.zip"
  layer_name = "lambda_layer_name"
} */