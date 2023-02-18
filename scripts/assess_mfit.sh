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

VERSION=`wget -O - https://mfit-release.storage.googleapis.com/latest`

wget https://mfit-release.storage.googleapis.com/${VERSION}/mfit-linux-collect.sh
chmod +x mfit-linux-collect.sh

wget https://mfit-release.storage.googleapis.com/${VERSION}/mfit
chmod +x mfit

# Run collection script locally
sudo ./mfit-linux-collect.sh

# commenting the line of code to avoid this error if this is not usefull code snippet -"error importing 'm2c-collect-*-*.tar': 1 error occurred:\n\t* 
# failed collecting 'ImportVM': could not read file 'm2c-collect-*-*.tar': 
# open m2c-collect-*-*.tar: no such file or directory\n\n\n\n"} "
# Import the VM collection details to mFIT DB
#./mfit discover import m2c-collect-*-*.tar

# Assess and generate a detailed HTML report
./mfit report --full --format html > mfit-report.html

# Assess and generate a JSON report
./mfit report --format json > mfit-report.json
