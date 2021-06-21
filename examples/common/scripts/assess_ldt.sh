#!/bin/bash

mkdir m4a
cd m4a

VERSION=`wget -O - https://anthos-migrate-release.storage.googleapis.com/latest`

wget https://anthos-migrate-release.storage.googleapis.com/${VERSION}/linux/amd64/m4a-fit-collect.sh
chmod +x m4a-fit-collect.sh

wget https://anthos-migrate-release.storage.googleapis.com/${VERSION}/linux/amd64/m4a-fit-analysis
chmod +x m4a-fit-analysis

sudo ./m4a-fit-collect.sh

./m4a-fit-analysis m4a-collect-*-*.tar
