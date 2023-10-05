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
# collection on all VMs via VMWare guest tools and authenticating to the VMs using
# username and password. The default USER and PASSWORD arguments will be used
# unless either of them is overriden for a specific VM.
#
err=$(mktemp --tmpdir mcdc-guest-err-XXXX)

# [START collect]

url_regex='^https?://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]\.[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]$'

read -r -p "CSV file name: " CSV_FILE
if [[ ! -r "$CSV_FILE" ]]; then
    echo "The file $CSV_FILE does not exist or can not be accessed."
    exit 1
fi

read -r -p "vSphere URL: " VSPHERE_URL
if ! [[ $VSPHERE_URL =~ $url_regex ]]; then
    echo "vSphere URL $VSPHERE_URL IS not a valid URL"
    exit 1
fi
read -r -p "vSphere username: " VSPHERE_USER
read -r -s -p "vSphere password: " VSPHERE_PASSWORD
echo ""
read -r -p "Default username: " DEFAULT_USER
read -r -s -p "Default password: " DEFAULT_PASSWORD

echo ""

# CSV fields
#NAME;PLATFORM VM ID;OS;IP;USERNAME;PASSWORD
while IFS=";" read -r vm_name vm_id os ip username password
do
   if [ -z "$username" ]
    then
      username=$DEFAULT_USER
    fi
    if [ -z "$password" ]
    then
          password=$DEFAULT_PASSWORD
    fi

    if [ ! -z "$vm_id" ]
    then
      # Note that the below only works for VMWare VMs
      # vm_id after the last slash if prefixed by vSphere IP
      mod_vm_id=$(echo "$vm_id" | sed 's/.*\///')
      mcdc discover vsphere guest --url $VSPHERE_URL -u $VSPHERE_USER -p $VSPHERE_PASSWORD --vm-user $username --vm-password $password $mod_vm_id
    else
      echo "Skipping VM: $vm_name because it has no VM ID"
    fi
 done < <(tail -n +1 $CSV_FILE)

# [END collect]

rm $err
