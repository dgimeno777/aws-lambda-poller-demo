resource "aws_sqs_queue" "lambda_poller" {
  name = "${local.local_resource_prefix}-${local.local_resource_suffix}"
}

resource "aws_lambda_event_source_mapping" "lambda_poller" {
  depends_on = [
    aws_sqs_queue.lambda_poller,
    aws_lambda_function.lambda_poller
  ]
  event_source_arn                   = aws_sqs_queue.lambda_poller.arn
  enabled                            = true
  function_name                      = aws_lambda_function.lambda_poller.arn
  batch_size                         = 1
  maximum_batching_window_in_seconds = 300
}
