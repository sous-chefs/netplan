# AGENTS.md

## Cookbook Purpose

This cookbook manages Netplan on Debian and Ubuntu. It provides resource-first APIs to install the distro `netplan.io` package and write `/etc/netplan/*.yaml` fragments from Ruby hashes or common typed resources.

## Agent Findings

* Netplan is a declarative network configuration renderer, not a long-running service. It renders YAML into backend configuration for renderers such as `networkd` and `NetworkManager`.
* Netplan reads configuration from `/lib/netplan`, `/etc/netplan`, and `/run/netplan`; `/etc/netplan` is the correct target for cookbook-managed persistent configuration.
* Files in `/etc/netplan` are merged by Netplan, so cookbook resources should write separate, lexically named fragments instead of editing cloud-init generated files such as `50-cloud-init.yaml`.
* Netplan YAML files should be root-only. This cookbook writes mode `0600` by default.
* `netplan generate` validates and generates backend configuration. `netplan apply` changes live networking and is opt-in through `apply true`.
* `netplan try` is rollback oriented and not the default Chef path because noninteractive remote convergence can leave nodes unreachable.
* The plan originally called the validation property `validate`, but that name collides with Chef's property validation internals. The implemented property is `validate_config`.

## Package Availability

### APT (Debian/Ubuntu)

* Debian 12: `netplan.io` `0.106-2+deb12u1`; `amd64` and `arm64` package pages are present.
* Debian 13: `netplan.io` `1.1.2-7`; `amd64` and `arm64` package pages are present.
* Ubuntu 22.04: `netplan.io` `0.106.1-7ubuntu0.22.04.4` on `amd64`; `arm64` package pages are present.
* Ubuntu 24.04: `netplan.io` `1.0-2ubuntu1.2` on `amd64`; `arm64` package pages are present.
* Ubuntu 26.04: `netplan.io` `1.2-1ubuntu5`; `amd64` and `arm64` package pages are present.

## Architecture Limitations

No cookbook-specific architecture restrictions are known. The cookbook relies on distro packages rather than an upstream package repository maintained by this cookbook.

## Source/Compiled Installation

Source builds are out of scope. The cookbook installs the distro `netplan.io` package only.

## Known Issues

* Do not enable `apply true` in Kitchen or routine CI examples; applying test network configuration can disrupt the test instance.
* Avoid managing cloud-init generated files directly. Add a new fragment with a lexical prefix instead.

## Test and CI Notes

* Dokken is the default local and CI strategy.
* The default Kitchen suite writes safe, non-applied examples and verifies `netplan generate`.
* Supported and tested platforms are Debian 12, Debian 13, Ubuntu 22.04, Ubuntu 24.04, and Ubuntu 26.04.
