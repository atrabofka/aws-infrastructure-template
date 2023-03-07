<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.47.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 3.18.1 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws"></a> [aws](#input\_aws) | AWS configurations | <pre>object({<br>    region = string<br>    azs    = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_layer_metadata"></a> [layer\_metadata](#input\_layer\_metadata) | Metadata tp be applied to all layer resources<br>{<br>  project: Name of the project the resources belong to<br>  environment: Name of the project's environment (e.g. dev, qa etc)<br>  layer: Name of the layer (e.g. 000-base etc)<br>} | <pre>object({<br>    project     = string<br>    environment = string<br>    layer       = string<br>  })</pre> | n/a | yes |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | VPC configurations | <pre>object({<br>    cidr             = string<br>    public_subnets   = list(string)<br>    private_subnets  = list(string)<br>    database_subnets = list(string)<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->