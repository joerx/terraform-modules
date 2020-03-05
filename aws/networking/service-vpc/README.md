# Sandbox VPC for SGP

The VPC itself must be created first before any of the peering connections can be applied. This is a problem with Terraform and there's no real workaround yet, except using resource targeting:

Create VPC first:

```sh
terraform apply -target=module.vpc
```

Then create the rest:

```sh
terraform apply
```

Note: this is not related to the peering module using data lookup, it would fail even if the RTB ids were passed to the module directly:

> The "for_each" value depends on resource attributes that cannot be determined
> until apply, so Terraform cannot predict how many instances will be created.

Kinda ridiculous since the plan is fully deterministic either way. Maybe TF 0.13 and modules as first-class citizen will fix this.
