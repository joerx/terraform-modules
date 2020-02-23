# VPC Peering Module

## Usage

VPCs will be looked up via `Name` tag so you only need to pass in the name of each VPC. Alternatively, use `local_vpc` or `peer_vpc` to pass in each VPCs details directly.

By default all RTBs in each VPC will receive routing rules, this can be customized via `local_rtb_filters` and `peer_rtb_filters` respectively.

```terraform
module "pcx_sandbox_tooling" {
  source = "git@github.com:/joerx/terraform-modules//aws/networking/vpc-peering?ref=<version>"

  # vpcs must exist before this module is applied
  local_vpc_name = "my-vpc"
  peer_vpc_name  = "my-other-vpc"
}
```

## Providers

| Name | Version |
|------|---------|
| aws  | ~> 2.48 |

## Inputs

| Name                | Description                                                                                                     | Type                                                                                                                       | Default | Required |
|---------------------|-----------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------|---------|:--------:|
| local\_rtb\_filters | Narrow down RTBs that receive pcx routes. By default, all RTBs will be used. Ignored if `local\_vpc` is != null | <code><pre>list(object({<br>    name   = string<br>    values = list(string)<br>  }))<br></pre></code>                     | `[]`    |    no    |
| local\_vpc          | Routing info for local (requester) VPC                                                                          | <code><pre>object({<br>    id      = string<br>    cidr    = string<br>    rtb_ids = list(string)<br>  })<br></pre></code> | n/a     |   yes    |
| local\_vpc\_name    | If set, routing info for local will be automatically looked up via Name tag. Ignored if `local\_vpc` != null    | `string`                                                                                                                   | n/a     |   yes    |
| peer\_rtb\_filters  | Narrow down RTBs that receive pcx routes. By default, all RTBs will be used. Ignored if `peer\_vpc` is != null  | <code><pre>list(object({<br>    name   = string<br>    values = list(string)<br>  }))<br></pre></code>                     | `[]`    |    no    |
| peer\_vpc           | Routing info for peer (accepter) VPC                                                                            | <code><pre>object({<br>    id      = string<br>    cidr    = string<br>    rtb_ids = list(string)<br>  })<br></pre></code> | n/a     |   yes    |
| peer\_vpc\_name     | If set, routing info for peer will be automatically looked up via Name. Ignored if `peer\_vpc` != null          | `string`                                                                                                                   | n/a     |   yes    |

## Outputs

| Name       | Description |
|------------|-------------|
| local\_vpc | n/a         |
| pcx\_id    | n/a         |
| peer\_vpc  | n/a         |

