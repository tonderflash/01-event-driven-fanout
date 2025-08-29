resource "aws_lambda_function" "orders_consumer" {
  filename         = "lambda-consumer.zip"
  function_name    = "orders-consumer-lambda"
  role             = var.lambda_execution_role_arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  timeout          = 30
  memory_size      = 128

  tags = {
    Environment = terraform.workspace
    Purpose     = "orders-consumer"
  }
}

resource "aws_lambda_event_source_mapping" "orders_consumer_from_sqs" {
  event_source_arn  = aws_sqs_queue.orders_queue.arn
  function_name     = aws_lambda_function.orders_consumer.function_name
  batch_size        = 1
  enabled           = true
}


