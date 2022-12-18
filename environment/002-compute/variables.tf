variable "aws" {
  description = "AWS configurations"
  type = object({
    region = string
    azs    = list(string)
  })
}
