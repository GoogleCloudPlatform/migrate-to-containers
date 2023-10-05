# Migrate to Containers useful scripts and utilities

The utility scripts are useful for setting up processing clusters and deployment clsuters and with migrated images.

## Table of Contents
* [Install M2C](install_m2c.sh) - This script creates a GKE with the necessary service account and installs Migrate to Containers on this cluster.

* [Add Compute Engine Source](add_ce_source.sh) - This script adds Google Compute Engine as a migration source and creates the necessary service account with required permissions.

* [Migration Center Discovery Client CLI](assess_mcdc.sh) - The script downloads and runs the migration center discovery client CLI(mcdc) on a Linux vm.

* [mcdc](./mcdc) - A directory containing a number of scripts showcasing how you might automate mcdc guest level coollection on multiple VMs.
