# Google Migrate for Anthos Pipeline

Documentation and code for the Google Migrate for Anthos Pipeline. The pipeline's purpose is to automate the migration process with support for doing bulk migrations of similar machines.

## Architecture

![Architecture Diagram](docs/assets/m4a-pipeline-architecture.png)

This solution consists of two pipelines, one which orchestrates the process, and the other which runs the migration process for each instance. The orchestration pipeline takes in a CSV file along with supporting migration plan patch files.
The CSV file defines an instance for each line, and the orchestration pipeline will trigger the migration pipeline for each one.

## Documentation

This can be found [here](docs/README.md).

## Contributing

All pipeline code can be found in the [`tekton/`](tekton/) directory. The pipeline code is divided into the `manifests` and the `scripts` that are injected into the manifests. This allows for the development of the scripts by running them locally.

The scripts require Python3, along with the following packages:

* PyYAML
* jsonpatch

There are sample inputs in the [`input/`](input/) directory.
