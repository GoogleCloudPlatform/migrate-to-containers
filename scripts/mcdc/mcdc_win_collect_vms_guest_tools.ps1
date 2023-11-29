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
# username and password. The default USERNAME and PASSWORD arguments will be used
# unless either of them is overriden for a specific VM.

$url_regex = "^https?://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]\.[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]$"

$CSV_FILE = Read-Host -Prompt "CSV file name:"
if (-not (Test-Path $CSV_FILE)) {
    Write-Host "The file $CSV_FILE does not exist or can not be accessed."
    exit 1
}

$VSPHERE_URL = Read-Host -Prompt "vSphere URL:"
if (-not ($VSPHERE_URL -match $url_regex)) {
    Write-Host "vSphere URL $VSPHERE_URL IS not a valid URL"
    exit 1
}

$vsphere_creds = Get-Credential -Message "Please enter your VMWare username and password."
$vsphere_creds.Username

$vm_creds = Get-Credential -Message "Please enter your default username and password to login to the VMs."
$vm_creds.Username

# CSV fields
#NAME;PLATFORM VM ID;OS;IP;USERNAME;PASSWORD
$FileContents = Get-Content -Path $CSV_FILE

ForEach ($Line in $FileContents) {
    $vm_name, $vm_id, $os, $ip, $username, $password = $Line.Split(";")

    if (-not $username) {
        $username = $vm_creds.Username
    }
    Write-Host "Password: $password"
    if (-not $password) {
        $password = $vm_creds.GetNetworkCredential().Password
    }

    if (-not $vm_id) {
        Write-Host "Skipping VM: $vm_name because it has no VM ID"
        continue
    }
    
    # Note that the below only works for VMWare VMs
    # vm_id after the last slash if prefixed by vSphere IP
    $mod_vm_id = Split-Path -Path $vm_id -Leaf
    mcdc discover vsphere guest --url $VSPHERE_URL -u $vsphere_creds.Username -p $vsphere_creds.GetNetworkCredential().Password --vm-user $username --vm-password $password $mod_vm_id -i
}
