# gtfsec:ingore:aws-sqs-enable-queue-encryption
module "sqs" {
  source = "../../modules/sqs-queue"

  name = "sample-queue"
}
