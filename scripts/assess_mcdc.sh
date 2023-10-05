#!/bin/bash
# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

mkdir m2c
cd m2c

VERSION=`wget -O - https://mcdc-release.storage.googleapis.com/latest`

wget https://mcdc-release.storage.googleapis.com/${VERSION}/mcdc-linux-collect.sh
chmod +x mcdc-linux-collect.sh

wget https://mcdc-release.storage.googleapis.com/${VERSION}/mcdc
chmod +x mcdc

# Run collection script locally
sudo ./mcdc-linux-collect.sh

# Import the VM collection details to mcdc DB
./mcdc discover import mcdc-collect-*-*.tar

# Assess and generate a detailed HTML report
./mcdc report --full --format html > mcdc-report.html

# Assess and generate a JSON report
./mcdc report --format json > mcdc-report.json
