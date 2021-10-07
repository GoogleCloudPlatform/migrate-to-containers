# Migrate for Anthos and GKE integrations

There are many integrations with other GCP/GKE/Anthos components which are common for many migrated workloads. This will be a collection of such comon patterns and allow you to quickly configure such integrations. 

## Table of Contents
* [Cloud SQL Auth Proxy](./cloudsql-proxy) - Connecting your migrated workload to [Cloud SQL](https://cloud.google.com/sql) using the [Cloud SQL Auth Proxy](https://cloud.google.com/sql/docs/mysql/sql-proxy)

* [Migration at Scale](./pipeline) - Powered by [Tekton](https://tekton.dev/), it allowes you to define templates for similar workloads and orchestrate the automation of migrating 10s to 100s of workloads without manual intervention. 