# Terraform Enterprise Module Library

[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.6-844FBA?logo=terraform&logoColor=white)](#)
[![AWS](https://img.shields.io/badge/AWS-VPC-232F3E?logo=amazonwebservices&logoColor=white)](#)
[![Azure](https://img.shields.io/badge/Azure-VNet-0078D4?logo=microsoftazure&logoColor=white)](#)

A growing library of **small, opinionated Terraform modules** designed to demonstrate reusable enterprise infrastructure patterns, module contracts, validation, tagging and CI rather than one-off monolithic configurations.

> These modules are reference implementations. They intentionally avoid organization-specific IAM, naming, policy and remote-state assumptions. Review provider versions, security requirements, network plans and cost implications before using them in a real environment.

## Module design principles

1. **Clear contract** — inputs and outputs should be understandable without reading every resource block.
2. **Safe defaults** — defaults are suitable for a lab/reference scenario and should not silently create unnecessary public exposure.
3. **Composition over monoliths** — modules solve bounded infrastructure problems and can be combined by environment/root modules.
4. **Validation close to inputs** — reject obviously invalid values early where Terraform can express the rule.
5. **Consistent metadata** — provide a predictable tagging model.
6. **No embedded credentials** — authentication remains outside module source.
7. **Version constraints** — declare Terraform/provider expectations explicitly.
8. **CI validation** — formatting and `terraform validate` are baseline quality gates.

## Current modules

| Module | Purpose | Status |
|---|---|---|
| [`modules/aws-vpc`](modules/aws-vpc) | VPC with public/private subnet tiers across AZs | Reference |
| [`modules/azure-vnet`](modules/azure-vnet) | Azure VNet with configurable application subnets | Reference |

## Repository structure

```text
.
├── README.md
├── docs/module-standard.md
├── modules/
│   ├── aws-vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── azure-vnet/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── examples/
│   ├── aws-vpc/main.tf
│   └── azure-vnet/main.tf
└── .github/workflows/terraform.yml
```

## AWS VPC example

```hcl
module "network" {
  source = "../../modules/aws-vpc"

  name       = "platform-dev"
  cidr_block = "10.20.0.0/16"

  availability_zones = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs = ["10.20.10.0/24", "10.20.11.0/24"]
  private_subnet_cidrs = ["10.20.20.0/24", "10.20.21.0/24"]

  tags = {
    Environment = "dev"
    Owner       = "platform"
  }
}
```

The reference module creates routing for the public tier but deliberately does **not** create a NAT Gateway by default. NAT design affects cost, availability and egress security and should be an explicit architecture decision.

## Azure VNet example

```hcl
module "network" {
  source = "../../modules/azure-vnet"

  name                = "vnet-platform-dev"
  location            = "eastus"
  resource_group_name = "rg-platform-dev"
  address_space       = ["10.30.0.0/16"]

  subnets = {
    app = "10.30.10.0/24"
    data = "10.30.20.0/24"
  }
}
```

## Quality gates

CI checks:

- `terraform fmt -check -recursive`
- provider initialization without backend
- `terraform validate` for examples

A production module lifecycle should additionally consider policy-as-code, security scanners, automated tests, release tags, semantic versioning, changelog generation and provider-upgrade testing.

## Module lifecycle

```text
Requirement
   ↓
Module contract
   ↓
Implementation
   ↓
Static validation / tests
   ↓
Peer review
   ↓
Versioned release
   ↓
Environment composition
   ↓
Plan / approval / apply
   ↓
Operational feedback
```

## Related projects

- [Hybrid Cloud Reference Architecture](https://github.com/DeeSanas/hybrid-cloud-reference-architecture)
- [OpenStack Private Cloud Reference Architecture](https://github.com/DeeSanas/openstack-private-cloud-reference-architecture)
- [Data Center EVPN-VXLAN Architecture](https://github.com/DeeSanas/datacenter-evpn-vxlan-architecture)

## Roadmap

- [x] AWS VPC baseline module
- [x] Azure VNet baseline module
- [x] Runnable composition examples
- [x] Terraform CI validation
- [ ] AWS Transit Gateway module
- [ ] Azure hub/spoke peering module
- [ ] OpenStack network module
- [ ] Kubernetes platform prerequisites module
- [ ] Automated module tests and security scanning
