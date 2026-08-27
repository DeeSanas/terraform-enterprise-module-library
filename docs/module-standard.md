# Terraform Module Standard

This repository uses the following baseline conventions for reusable modules.

## Interface

Every module should document:

- purpose and non-goals;
- required inputs;
- optional inputs and defaults;
- outputs intended for composition;
- provider/Terraform version constraints;
- security and cost implications.

## Code organization

For modules that grow beyond a small file:

```text
main.tf       # resources and data sources
variables.tf  # module contract / input validation
outputs.tf    # composition interface
versions.tf   # optional dedicated provider/version file
README.md     # usage and caveats
```

## Naming

The module should not hard-code a company-specific naming convention unless naming is the module's explicit purpose. Accept names/prefixes as inputs and expose tags/labels for environment metadata.

## State and authentication

Reusable modules do not define a backend and do not embed credentials. Backend strategy belongs to root/environment configuration. Authentication should use supported provider mechanisms and secure workload/CI identities.

## Security

Avoid defaults that create public exposure merely to make a demo easier. Security groups/firewall rules, public IPs, permissive IAM and secrets require explicit design decisions.

## Cost

A module should call out resources with significant fixed or traffic-based cost. For example, NAT gateways, private interconnects, high-performance storage and managed security appliances should not be hidden behind an innocent-looking default.

## Quality gates

Minimum:

```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

Recommended for mature modules:

- unit/integration tests;
- TFLint;
- provider/security scanning;
- policy-as-code;
- example plans in isolated test accounts/subscriptions;
- semantic versioning and changelog;
- upgrade tests for Terraform/provider versions.

## Change policy

Breaking changes to input/output contracts should be deliberate and versioned. Deprecate where practical rather than silently changing behavior for existing consumers.
