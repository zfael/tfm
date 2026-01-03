# TFM - Terraform Modules

Reusable Terraform modules for various cloud providers.

## Structure

```
tfm/
├── modules/           # Primitives (building blocks)
│   └── aws/           # AWS modules
│       ├── organization/
│       ├── accounts/
│       └── identity-center/
└── recipes/           # Compositions (batteries-included)
    └── aws/           # AWS recipes
        └── organization/
```

## Usage

Browse the provider-specific folders for available modules and recipes. Each module/recipe has its own README with usage instructions.

### Modules

Individual building blocks for specific resources:

```hcl
module "organization" {
  source = "github.com/zfael/tfm//modules/aws/organization"
  # ...
}
```

### Recipes

Pre-wired compositions that combine multiple modules:

```hcl
module "my_org" {
  source = "github.com/zfael/tfm//recipes/aws/organization"
  # ...
}
```

## Available Modules

| Provider | Module | Description |
|----------|--------|-------------|
| AWS | [organization](./modules/aws/organization/) | OUs and SCPs |
| AWS | [accounts](./modules/aws/accounts/) | Member accounts |
| AWS | [identity-center](./modules/aws/identity-center/) | SSO users, permission sets |

## Available Recipes

| Provider | Recipe | Description |
|----------|--------|-------------|
| AWS | [organization](./recipes/aws/organization/) | Complete org setup |

## Testing

Modules include unit tests using Terraform's built-in test framework (requires TF 1.6+).

```bash
# Run tests for a specific module
cd modules/aws/organization
terraform init -backend=false
terraform test
```

## License

MIT