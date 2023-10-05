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
# This script reads the input CSV_FILE and iterates over all VMs, running guest
# collection on all LINUX VMs via ssh and authenticating to the VMs using an identify-file and
# passphrase if set. To set the identity-file path the environment variable
# MCDC_SSH_IDENTITY_FILE must be set and if a passphrase is required then the
# environment variable MCDC_SSH_PASSPHRASE must be set to the passphrase value
if [[ -z "${MCDC_SSH_IDENTITY_FILE}" ]]; then
  echo "MCDC_SSH_IDENTITY_FILE environment must be set"
  exit
fi

read -r -p "CSV file name: " CSV_FILE
if [[ ! -r "$CSV_FILE" ]]; then
    echo "The file  $CSV_FILE does not exist or can not be accessed."
    exit 1
fi

read -r -p "Default username: " DEFAULT_USER

echo ""

while IFS=";" read -r vm_name vm_id os ip username password
do
   if [ -z "$username" ]
    then
      username=$DEFAULT_USER
    fi

    shopt -s nocasematch # case insenitive match
    if [[ "$os" == *"linux"* ]] || [[ "$os" == *"ubuntu"* ]] || [[ "$os" == *"centos"* ]];
    then
      if [ ! -z "$ip" ]
      then
        mcdc discover ssh --ssh-client embedded --user $username $ip || continue
      else
        echo "Skipping VM: $vm_name because it has no IP address"
      fi
    else
      echo "Skipping $os VM: $vm_name"
    fi
 done < <(tail -n +1 $CSV_FILE)
