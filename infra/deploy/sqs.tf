# Cola principal para procesar órdenes
resource "aws_sqs_queue" "orders_queue" {
  name                      = "orders-processing-queue"
  delay_seconds             = 0  # Sin delay para procesamiento inmediato
  max_message_size          = 262144  # 256KB para archivos JSON
  message_retention_seconds = 1209600  # 14 días (máximo)
  receive_wait_time_seconds = 20  # Long polling para eficiencia
  
  # Política de reintentos
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.orders_dlq.arn
    maxReceiveCount     = 3
  })

  tags = {
    Environment = "production"
    Purpose     = "orders-processing"
  }
}

# Dead Letter Queue para mensajes fallidos
resource "aws_sqs_queue" "orders_dlq" {
  name                      = "orders-processing-dlq"
  message_retention_seconds = 1209600  # 14 días
  
  tags = {
    Environment = "production"
    Purpose     = "orders-dlq"
  }
}

# Suscripción SQS al topic SNS
resource "aws_sns_topic_subscription" "orders_sqs_subscription" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.orders_queue.arn
}
