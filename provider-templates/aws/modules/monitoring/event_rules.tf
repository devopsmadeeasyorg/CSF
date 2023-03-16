resource "aws_cloudwatch_event_target" "lambda" {
  rule      = "${aws_cloudwatch_event_rule.lambda_rule.id}"
  arn       = "${var.lambdaarn}"
}


resource "aws_cloudwatch_event_rule" "lambda_rule" {
  name        = "lamda_rule"
  description = "Capture each AWS Console Sign In"
  schedule_expression = "rate(5 minutes)"
}

