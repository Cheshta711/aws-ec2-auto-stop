provider "aws" {
  region = "ap-south-1"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-ec2-stop-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "ec2_policy" {
  name = "ec2-stop-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ec2:DescribeInstances",
        "ec2:StopInstances"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_lambda_function" "auto_stop" {
  function_name = "auto-stop-ec2"
  role          = aws_iam_role.lambda_role.arn
  handler       = "auto_stop.lambda_handler"
  runtime       = "python3.9"
  filename      = "../lambda/auto_stop.zip"
}

resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "ec2-stop-schedule"
  schedule_expression = "rate(1 hour)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.schedule.name
  target_id = "lambda"
  arn       = aws_lambda_function.auto_stop.arn
}

resource "aws_lambda_permission" "allow_event" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auto_stop.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn
}
