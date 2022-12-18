
resource "aws_sqs_queue" "deadletter" {
  name = var.name
  tags = {
    "Environment"       = var.environment
    "Version"           = var.envVersion
    "Terraform managed" = "true"
    "GithubRepo"        = "terraform-aws-sqs"
    "GithubOrg"         = "terraform-aws-modules"
  }
  receive_wait_time_seconds = 20
}

resource "aws_sqs_queue" "queue" {
  for_each = var.queues
  name     = "${var.project}-${each.value}-${var.environment}-${var.envVersion}"
  tags = {
    "Environment"       = var.environment
    "Version"           = var.envVersion
    "Terraform managed" = "true"
    "GithubRepo"        = "terraform-aws-sqs"
    "GithubOrg"         = "terraform-aws-modules"
  }
  receive_wait_time_seconds = 20
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.deadletter.arn,
    maxReceiveCount     = 5
  })
  depends_on = [
    aws_sqs_queue.deadletter
  ]
}
