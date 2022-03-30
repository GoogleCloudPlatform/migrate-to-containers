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
# This script depends on the existence of govc CLI. You can download govc from https://github.com/vmware/govmomi/releases
#
# This script reads the input CSV_FILE and iterates over all VMs, running guest
# collection on all Windows VMs via VMWare guest tools and authenticating to the VMs using
# username and password. The default USER and PASSWORD arguments will be used
# unless either of them is overriden for a specific VM.
#
err=$(mktemp --tmpdir mfit-guest-err-XXXX)

read -r -p "VSphere URL: " VSPHERE_URL
read -r -p "VSphere username: " VSPHERE_USER
read -r -s -p "VSphere password: " VSPHERE_PASSWORD
echo ""
read -r -p "VM username: " VM_USER
read -r -s -p "VM password: " VM_PASSWORD

echo ""

export GOVC_URL=$VSPHERE_URL
export GOVC_USERNAME=$VSPHERE_USER
export GOVC_PASSWORD=$VSPHERE_PASSWORD
export MFIT_VSPHERE_PASSWORD=$VSPHERE_PASSWORD

export MFIT_GUEST_VM_USER=$VM_USER
export MFIT_GUEST_VM_PASSWORD=$VM_PASSWORD

govc find . -type m -runtime.powerState poweredOn -guest.toolsRunningStatus guestToolsRunning | gawk -F '/' '{print $NF}' | xargs -I{} mfit discover vsphere --url $URL -u root -i guest {}

# CSV fields
#NAME;PLATFORM VM ID;COLLECTED DATA;OS;IP;USERNAME;PASSWORD
while IFS=";" read -r vm_name vm_id collected_data os ip username password
do
   if [ -z "$username" ]
    then
      username=$DEFAULT_USER
    fi
    if [ -z "$password" ]
    then
          password=$DEFAULT_PASSWORD
    fi

    #echo "VM name is : $vm_name"
    #echo "VM ID is : $vm_id"
    #echo "VM OS is : $os"
    #echo "Username : $username"


    if [ "$os" = "Windows" ]
    then
      if [ ! -z "$vm_id" ]
      then
        # vm_id after the last slash if prefixed by vsphere IP:
        mod_vm_id=$(echo "$vm_id" | sed 's/.*\///')
        mfit discover vsphere guest --url $VSPHERE_URL -u $VSPHERE_USER -p $VSPHERE_PASSWORD --vm-user $username --vm-password $password $mod_vm_id
      else
        echo "Skipping VM: $vm_name because it has no VM ID"
      fi
    else
      echo "Skipping $os VM: $vm_name"
    fi
 done < <(tail -n +1 $CSV_FILE)

rm $err
