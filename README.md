# Infrastructure Automation Library

[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.6-844FBA?logo=terraform&logoColor=white)](#)
[![Ansible](https://img.shields.io/badge/Automation-Ansible-EE0000?logo=ansible&logoColor=white)](#)
[![CI](https://img.shields.io/badge/Validation-GitHub%20Actions-2088FF?logo=githubactions&logoColor=white)](#)

A growing collection of **reusable infrastructure automation patterns** demonstrating Terraform module engineering, Ansible configuration management, validation, tagging and CI rather than one-off deployment scripts.

> These are reference implementations. They intentionally avoid organization-specific credentials, IAM, naming, policy and remote-state assumptions. Review provider/module versions, security requirements, network plans and operational controls before using them in a real environment.

## Automation principles

1. **Clear contracts** — inputs, outputs and role responsibilities should be understandable without reverse-engineering every task/resource.
2. **Safe reference defaults** — examples should not silently create unnecessary public exposure or destructive changes.
3. **Composition over monoliths** — bounded modules/roles can be combined by environment and platform teams.
4. **Validation close to source** — formatting, syntax and semantic validation are baseline quality gates.
5. **Consistent metadata** — tags, naming and ownership are deliberate rather than incidental.
6. **No embedded credentials** — authentication remains outside repository source.
7. **Version constraints** — tool/provider/collection expectations are declared explicitly.
8. **Idempotence and reviewability** — re-running automation should converge toward declared state where supported.

## Current Terraform modules

| Module | Purpose | Status |
|---|---|---|
| [`modules/aws-vpc`](modules/aws-vpc) | VPC with public/private subnet tiers across AZs | Reference |
| [`modules/azure-vnet`](modules/azure-vnet) | Azure VNet with configurable application subnets | Reference |

## Configuration-management project

### [Ansible Infrastructure Baseline](projects/ansible-infrastructure-baseline)

A reusable Linux baseline demonstrating inventory separation, role structure, defaults, handlers, package/time-service configuration and CI syntax validation.

This project illustrates the architectural distinction between:

```text
Terraform / IaC
    ↓
Infrastructure provisioning
    ↓
VMs / networks / cloud resources
    ↓
Ansible
    ↓
OS configuration / packages / platform baseline
```

## Repository structure

```text
.
├── README.md
├── docs/module-standard.md
├── modules/
│   ├── aws-vpc/
│   └── azure-vnet/
├── examples/
│   ├── aws-vpc/
│   └── azure-vnet/
├── projects/
│   └── ansible-infrastructure-baseline/
│       ├── ansible.cfg
│       ├── inventory/
│       ├── playbooks/
│       └── roles/common/
└── .github/workflows/
    ├── terraform.yml
    └── ansible-baseline.yml
```

## AWS VPC example

```hcl
module "network" {
  source = "../../modules/aws-vpc"

  name       = "platform-dev"
  cidr_block = "10.20.0.0/16"

  availability_zones  = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.20.10.0/24", "10.20.11.0/24"]
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
    app  = "10.30.10.0/24"
    data = "10.30.20.0/24"
  }
}
```

## Quality gates

Terraform CI checks include:

- `terraform fmt -check -recursive`;
- provider initialization without backend;
- `terraform validate` for examples.

Ansible CI checks include:

- required collection installation;
- inventory parsing;
- `ansible-playbook --syntax-check`.

A production automation lifecycle should additionally consider policy-as-code, security scanners, automated integration tests, release tags, semantic versioning, changelogs, provider/collection upgrade testing and controlled rollout evidence.

## Automation lifecycle

```text
Requirement
   ↓
Module / role contract
   ↓
Implementation
   ↓
Static validation / tests
   ↓
Peer review
   ↓
Versioned change
   ↓
Environment composition
   ↓
Plan / check mode / approval
   ↓
Apply / controlled rollout
   ↓
Operational feedback & drift remediation
```

## Related projects

- [Hybrid Cloud Reference Architecture](https://github.com/DeeSanas/hybrid-cloud-reference-architecture)
- [OpenStack Private Cloud Reference Architecture](https://github.com/DeeSanas/openstack-private-cloud-reference-architecture)
- [Data Center EVPN-VXLAN Architecture](https://github.com/DeeSanas/datacenter-evpn-vxlan-architecture)
- [VMware to OpenStack Migration Framework](https://github.com/DeeSanas/vmware-to-openstack-migration-framework)

## Roadmap

- [x] AWS VPC baseline module
- [x] Azure VNet baseline module
- [x] Runnable Terraform composition examples
- [x] Terraform CI validation
- [x] Ansible Linux infrastructure baseline
- [x] Ansible CI syntax validation
- [ ] AWS Transit Gateway module
- [ ] Azure hub/spoke peering module
- [ ] OpenStack network module
- [ ] Kubernetes platform prerequisites module
- [ ] Automated module integration tests and security scanning
