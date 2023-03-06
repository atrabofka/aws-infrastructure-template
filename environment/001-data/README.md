<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.47.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.47.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_main_db"></a> [main\_db](#module\_main\_db) | terraform-aws-modules/rds/aws | 5.2.1 |
| <a name="module_main_db_security_group"></a> [main\_db\_security\_group](#module\_main\_db\_security\_group) | terraform-aws-modules/security-group/aws | 4.16.1 |

## Resources

| Name | Type |
|------|------|
| [aws_subnets.main_db_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.main_db_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws"></a> [aws](#input\_aws) | AWS configurations | <pre>object({<br>    region = string<br>    azs    = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_layer_metadata"></a> [layer\_metadata](#input\_layer\_metadata) | Metadata tp be applied to all layer resources<br>{<br>  project: Name of the project the resources belong to<br>  environment: Name of the project's environment (e.g. dev, qa etc)<br>  layer: Name of the layer (e.g. 000-base etc)<br>} | <pre>object({<br>    project     = string<br>    environment = string<br>    layer       = string<br>  })</pre> | n/a | yes |
| <a name="input_main_db"></a> [main\_db](#input\_main\_db) | Main DB configurations | <pre>object({<br>    name                = string<br>    family              = string<br>    engine_version      = string<br>    tier                = string<br>    multiaz             = bool<br>    disk_size           = number<br>    disk_max_size       = number<br>    internet_gateway    = bool<br>    deletion_protection = bool<br>    backup_retention    = number<br>    encrypted           = bool<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->