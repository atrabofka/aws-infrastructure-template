module "sqs" {
  source = "../../modules/sqs-queue"

  name = "sample-queue"
}
