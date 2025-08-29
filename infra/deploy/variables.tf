variable "tf_state_bucket" {
  description = "The name of the S3 bucket to store the Terraform state file"
  default     = "event-driven-app-tf-state"
}

variable "tf_state_lock_table" {
  description = "The name of the DynamoDB table to store the Terraform state lock"
  default     = "event-driven-app-tf-lock"
}

variable "project" {
  description = "The name of the project"
  default     = "event-driven-app"
}

variable "contact" {
  description = "The contact email for the project"
  default     = "g594@gmail.com"
}

variable "lambda_execution_role_arn" {
  description = "ARN del rol de ejecucion de Lambda preexistente"
  type        = string
}
