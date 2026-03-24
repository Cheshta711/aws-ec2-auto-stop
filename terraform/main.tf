terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
    random = {
      source  = "hashicorp/random"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# -------------------------------
# RANDOM SUFFIX (for unique names)
# -------------------------------
resource "random_id" "suffix" {
  byte_length = 4
}

# -------------------------------
# IAM ROLE FOR LAMBDA
# -------------------------------
resource "aws_iam_role" "lambda_role" {
  name = "lambda-ec2-stop-role-${random_id.suffix.hex}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# -------------------------------
# IAM POLICY
# -------------------------------
resource "aws_iam_policy" "ec2_policy" {
  name = "ec2-stop-policy-${random_id.suffix.hex}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:StopInstances"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:*",
          "cloudwatch:PutMetricData"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

# -------------------------------
# LAMBDA FUNCTION
# -------------------------------
resource "aws_lambda_function" "auto_stop" {
  function_name = "ec2-auto-stop-${random_id.suffix.hex}"
  role          = aws_iam_role.lambda_role.arn
  handler       = "auto_stop.lambda_handler"
  runtime       = "python3.9"

  filename         = "../lambda/auto_stop.zip"
  source_code_hash = filebase64sha256("../lambda/auto_stop.zip")
}

# -------------------------------
# EVENTBRIDGE SCHEDULE
# -------------------------------
resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "ec2-stop-schedule-${random_id.suffix.hex}"
  schedule_expression = "rate(1 hour)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.schedule.name
  target_id = "lambda-target"
  arn       = aws_lambda_function.auto_stop.arn
}

# अनुमति for EventBridge to invoke Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auto_stop.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn
}