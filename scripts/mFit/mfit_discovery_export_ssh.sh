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
#
# This script lists all the VMs that were discoverd by mfit and outputs to
# stdout in CSV format.
# The CSV format fields are: Name;Platform VM ID;OS Family;IP;USERNAME;PASSWORD 
# The USERNAME and PASSWORD fields will NOT be set by the script and can be
# modified by the user if unique credentials are required for a VM.
# General information is written to stderr.

err=$(mktemp --tmpdir mfit-discovery-export-err-XXXX)

vms=$(mfit discover ls | tail -n +2 | awk -F ' *\t' '{ split($6, ips, /, /); print $2";;"$4";"$5";"ips[1]";"}')
printf "%s\n" "Name;Platform VM ID;OS Family;IP;USERNAME;PASSWORD"
printf "%s\n" "$vms"

rm $err
