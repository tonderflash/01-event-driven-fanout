resource "aws_iam_user" "cd" {
  name = "event-driven-app-cd"
}

resource "aws_iam_access_key" "cd" {
  user = aws_iam_user.cd.name
}

#########################################################
# Policy for Teraform backend to S3 and DynamoDB access #
#########################################################

data "aws_iam_policy_document" "tf_backend" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.tf_state_bucket}"]
  }

  statement {
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = [
      "arn:aws:s3:::${var.tf_state_bucket}/tf-state-deploy",
      "arn:aws:s3:::${var.tf_state_bucket}/tf-state-deploy/*",
      "arn:aws:s3:::${var.tf_state_bucket}/tf-state-deploy-env/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = ["arn:aws:dynamodb:*:*:table/${var.tf_state_lock_table}"]
  }
}

resource "aws_iam_policy" "tf_backend" {
  name        = "${aws_iam_user.cd.name}-tf-s3-dynamodb"
  description = "Allow user to use S3 and DynamoDB for TF backend resources"
  policy      = data.aws_iam_policy_document.tf_backend.json
}

resource "aws_iam_user_policy_attachment" "tf_backend" {
  user       = aws_iam_user.cd.name
  policy_arn = aws_iam_policy.tf_backend.arn
}

#########################################################
# Policy for Deploy infrastructure resources            #
#########################################################

data "aws_iam_policy_document" "deploy_resources" {
  # S3 permissions - Comprehensive list for Terraform management
  statement {
    effect = "Allow"
    actions = [
      # Basic bucket operations
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:ListBucket",
      "s3:HeadBucket",
      "s3:GetBucketLocation",
      
      # Versioning
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning",
      
      # Notifications
      "s3:PutBucketNotification",
      "s3:GetBucketNotification",
      
      # Tagging
      "s3:PutBucketTagging",
      "s3:GetBucketTagging",
      
      # Policies and ACLs
      "s3:PutBucketPolicy",
      "s3:GetBucketPolicy",
      "s3:DeleteBucketPolicy",
      "s3:PutBucketAcl",
      "s3:GetBucketAcl",
      
      # CORS
      "s3:GetBucketCORS",
      "s3:PutBucketCORS",
      "s3:DeleteBucketCORS",
      
      # Encryption
      "s3:GetEncryptionConfiguration",
      "s3:PutEncryptionConfiguration",
      
      # Lifecycle
      "s3:GetLifecycleConfiguration",
      "s3:PutLifecycleConfiguration",
      
      # Public Access Block
      "s3:GetBucketPublicAccessBlock",
      "s3:PutBucketPublicAccessBlock",
      
      # Logging
      "s3:GetBucketLogging",
      "s3:PutBucketLogging",
      
      # Website configuration
      "s3:GetBucketWebsite",
      "s3:PutBucketWebsite",
      "s3:DeleteBucketWebsite",
      
      # Replication
      "s3:GetReplicationConfiguration",
      "s3:PutReplicationConfiguration",
      
      # Request payment
      "s3:GetBucketRequestPayment",
      "s3:PutBucketRequestPayment"
    ]
    resources = [
      "arn:aws:s3:::event-driven-orders-*",
      "arn:aws:s3:::event-driven-orders-*/*"
    ]
  }

  # SNS permissions
  statement {
    effect = "Allow"
    actions = [
      "sns:CreateTopic",
      "sns:DeleteTopic",
      "sns:GetTopicAttributes",
      "sns:SetTopicAttributes",
      "sns:ListTopics",
      "sns:TagResource",
      "sns:UntagResource",
      "sns:ListTagsForResource"
    ]
    resources = [
      "arn:aws:sns:*:*:s3-event-notification-topic"
    ]
  }

  # IAM permissions for SNS topic policies
  statement {
    effect = "Allow"
    actions = [
      "iam:GetRole",
      "iam:PassRole"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "deploy_resources" {
  name        = "${aws_iam_user.cd.name}-deploy-resources"
  description = "Allow user to create and manage deployment resources (S3, SNS)"
  policy      = data.aws_iam_policy_document.deploy_resources.json
}

resource "aws_iam_user_policy_attachment" "deploy_resources" {
  user       = aws_iam_user.cd.name
  policy_arn = aws_iam_policy.deploy_resources.arn
}

