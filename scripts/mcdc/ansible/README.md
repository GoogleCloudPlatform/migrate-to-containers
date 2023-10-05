This directory contains playbooks to collect mcdc guest data using ansible

## Overview

There are 2 playbooks, one for collecting from linux machines, and one for collecting from windows machines.

The playbooks assume that the mcdc collect scripts are downloaded in the working directory. See usage section for how to download them.

Each playbook uploads the script to the target machine, runs mcdc, and then downloads the result to the ./artifacts directoy.

You can then import the resulting artifact into mcdc.

The playbooks are written to be simple, so that they will be easy to modify for your use case.

## Usage

1. 

Create a working directory:

```sh
mkdir mcdc
cd mcdc
```

2.

Download the mcdc windows and linux scripts

```sh
version=$(curl -s https://mcdc-release.storage.googleapis.com/latest)
curl -O "https://mcdc-release.storage.googleapis.com/$version/mcdc-linux-collect.sh"
curl -O "https://mcdc-release.storage.googleapis.com/$version/mcdc-windows-collect.ps1"
```

3.

Download the playbooks

```sh
curl -O "https://raw.githubusercontent.com/GoogleCloudPlatform/migrate-to-containers/main/scripts/mcdc/ansible/run-mcdc-linux.yaml"
curl -O "https://raw.githubusercontent.com/GoogleCloudPlatform/migrate-to-containers/main/scripts/mcdc/ansible/run-mcdc-windows.yaml"
```

4.

Run the playbooks against your machines as you usually would.

e.g.

```sh
ansible-playbook -i /path/to/inventory.yaml ./run-mcdc-linux.yaml
```

5.

import the discovered artifacts into mcdc:

```sh
(shopt -s globstar; mcdc discover import ./artifacts/**/mcdc-collect.*)
```

