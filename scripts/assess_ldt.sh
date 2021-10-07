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

mkdir m4a
cd m4a

VERSION=`wget -O - https://anthos-migrate-release.storage.googleapis.com/latest`

wget https://anthos-migrate-release.storage.googleapis.com/${VERSION}/linux/amd64/m4a-fit-collect.sh
chmod +x m4a-fit-collect.sh

wget https://anthos-migrate-release.storage.googleapis.com/${VERSION}/linux/amd64/m4a-fit-analysis
chmod +x m4a-fit-analysis

sudo ./m4a-fit-collect.sh

./m4a-fit-analysis m4a-collect-*-*.tar
