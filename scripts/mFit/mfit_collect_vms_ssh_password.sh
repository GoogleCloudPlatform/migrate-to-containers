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
# collection on all LINUX VMs via ssh and authenticating to the VMs using
# username and password. The default USERNAME and PASSWORD arguments will e used
# unless either of them is overriden for a specific VM.
#
read -r -p "CSV file name: " CSV_FILE
if [[ ! -r "$CSV_FILE" ]]; then
    echo "The file $CSV_FILE does not exist or can not be accessed."
    exit 1
fi

read -r -p "Default username: " DEFAULT_USER
read -r -s -p "Default password: " DEFAULT_PASSWORD

echo ""

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

    shopt -s nocasematch # case insensitive match
    if [[ "$os" == *"linux"* ]] || [[ "$os" == *"ubuntu"* ]] || [[ "$os" == *"centos"* ]];
    then
      if [ ! -z "$ip" ]
      then
        mfit discover ssh --ssh-client embedded --user $username --password $password $ip || continue
      else
        echo "Skipping VM: $vm_name because it has no IP address"
      fi
    else
      echo "Skipping $os VM: $vm_name"
    fi
 done < <(tail -n +1 $CSV_FILE)
