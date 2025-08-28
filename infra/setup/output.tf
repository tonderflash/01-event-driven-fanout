# Outputs for AWS IAM User Credentials
# --------------------------------------
# This file defines Terraform outputs for the IAM user's access credentials.
# These outputs include:
# 1. The Access Key ID (used as a username equivalent for authentication).
# 2. The Secret Access Key (used as the password for the IAM user).
#
# The "sensitive" attribute is used for the secret key output to ensure it 
# is not displayed in plain text during Terraform operations, enhancing 
# security and minimizing exposure of sensitive information.
# 
# These outputs are essential for integrating the IAM user's credentials 
# into external systems such as CI/CD pipelines (e.g., GitHub Actions or 
# GitLab CI/CD).

output "cd_user_access_key_id" {
  description = "The access key ID for the CD user"
  value       = aws_iam_access_key.cd.id

}

output "cd_user_access_key_secret" {
  description = "The secret access key for the CD user"
  value       = aws_iam_access_key.cd.secret
  sensitive   = true
}
