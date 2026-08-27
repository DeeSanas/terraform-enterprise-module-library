# Ansible Infrastructure Baseline

[![Ansible](https://img.shields.io/badge/Automation-Ansible-EE0000?logo=ansible&logoColor=white)](#)
[![Linux](https://img.shields.io/badge/Platform-Linux-FCC624?logo=linux&logoColor=black)](#)
[![Status](https://img.shields.io/badge/Status-Reference%20Implementation-success)](#)

A reference **Ansible infrastructure baseline** for establishing repeatable Linux server configuration across cloud, private-cloud and data-center environments.

> This is a portfolio/reference implementation. Package names, repositories, users, SSH controls, logging, NTP, hardening and compliance settings must be adapted to the target operating system and organizational policy.

## Design objectives

- make server baseline configuration repeatable and reviewable;
- separate inventory, playbooks and reusable roles;
- avoid embedding passwords or private keys in source;
- enforce common packages and operational configuration;
- prepare hosts for monitoring and platform integration;
- support idempotent re-runs rather than one-time build scripts;
- validate playbook syntax in CI.

## Repository structure

```text
ansible-infrastructure-baseline/
├── README.md
├── ansible.cfg
├── inventory/example.ini
├── playbooks/site.yml
└── roles/common/
    ├── defaults/main.yml
    ├── handlers/main.yml
    └── tasks/main.yml
```

## Baseline responsibilities

The `common` role demonstrates:

- installation of standard operational packages;
- timezone management;
- NTP/chrony service management;
- creation of a managed configuration directory;
- deployment of a baseline marker file;
- restart handling when configuration changes.

It intentionally avoids destructive firewall, SSH or kernel-hardening changes that could lock out a host without environment-specific testing.

## Example execution

```bash
ansible-playbook -i inventory/example.ini playbooks/site.yml --check
```

For a real environment, replace the example inventory with dynamic inventory or controlled environment inventories and use a secrets manager or Ansible Vault for sensitive variables.

## Operating model

```text
Inventory / CMDB
      ↓
Variables & policy
      ↓
Reusable roles
      ↓
Syntax / lint checks
      ↓
Change review
      ↓
Check mode / pilot hosts
      ↓
Controlled rollout
      ↓
Verification & drift remediation
```

## Production validation checklist

- supported OS distributions/releases
- privileged-access and `become` model
- SSH host-key policy
- secret storage and rotation
- package repository ownership
- proxy configuration
- NTP/time source requirements
- logging/monitoring agent integration
- firewall and SELinux/AppArmor policy
- CIS or organization-specific hardening baseline
- patching/reboot coordination
- rollback and break-glass access

## Portfolio value

This project complements Terraform by demonstrating the distinction between **infrastructure provisioning** and **operating-system/configuration management**.
