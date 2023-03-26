This directory contains playbooks to collect mfit guest data using ansible

## Overview

There are 2 playbooks, one for collecting from linux machines, and one for collecting from windows machines.

The playbooks assume that the mfit collect scripts are downloaded in the working directory. See usage section for how to download them.

Each playbook uploads the script to the target machine, runs mfit, and then downloads the result to the ./artifacts directoy.

You can then import the resulting artifact into mfit.

The playbooks are written to be simple, so that they will be easy to modify for your use case.

## Usage

1. 

Create a working directory:

```sh
mkdir mfit
cd mfit
```

2.

Download the mfit windows and linux scripts

```sh
version=$(curl -s https://mfit-release.storage.googleapis.com/latest)
curl -O "https://mfit-release.storage.googleapis.com/$version/mfit-linux-collect.sh"
curl -O "https://mfit-release.storage.googleapis.com/$version/mfit-windows-collect.ps1"
```

3.

Download the playbooks

```sh
curl -O "https://raw.githubusercontent.com/GoogleCloudPlatform/migrate-to-containers/main/scripts/mFit/ansible/run-mfit-linux.yaml"
curl -O "https://raw.githubusercontent.com/GoogleCloudPlatform/migrate-to-containers/main/scripts/mFit/ansible/run-mfit-windows.yaml"
```

4.

Run the playbooks against your machines as you usually would.

e.g.

```sh
ansible-playbook -i /path/to/inventory.yaml ./run-mfit-linux.yaml
```

5.

import the discovered artifacts into mfit:

```sh
(shopt -s globstar; mfit discover import ./artifacts/**/mfit-collect.*)
```

