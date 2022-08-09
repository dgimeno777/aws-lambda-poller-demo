resource "aws_iam_role" "lambda_poller" {
  name = "${local.local_resource_prefix}-${local.local_resource_suffix}"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_exec" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_poller.name
}

resource "aws_iam_role_policy_attachment" "lambda_poller" {
  policy_arn = aws_iam_policy.lambda_poller.arn
  role       = aws_iam_role.lambda_poller.name
}

resource "aws_iam_policy" "lambda_poller" {
  name = "${local.local_resource_prefix}-${local.local_resource_suffix}"
  policy = jsonencode({
    "Version" : "2012-10-17"
    "Statement" : [
      {
        "Action" : "sqs:*"
        "Resource" : "*"
        "Effect" : "Allow"
      }
    ]
  })
}

data "archive_file" "lambda_poller" {
  type             = "zip"
  source_file      = "${path.module}/../../lambda/lambda/handler.py"
  output_file_mode = "0666"
  output_path      = "${path.module}/build/lambda.zip"
}

resource "aws_lambda_function" "lambda_poller" {
  filename         = data.archive_file.lambda_poller.output_path
  function_name    = "${local.local_resource_prefix}-${local.local_resource_suffix}"
  role             = aws_iam_role.lambda_poller.arn
  handler          = "handler.lambda_handler"
  source_code_hash = data.archive_file.lambda_poller.output_base64sha256
  runtime          = "python3.9"
}
