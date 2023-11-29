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
# This script lists all the VMs that were discoverd by mcdc and outputs to
# a file named vms.csv.
# The CSV format fields are: Name;Platform VM ID;OS;
# The USERNAME and PASSWORD fields will NOT be set by the script and can be
# modified by the user if unique credentials are required for a VM.

$tmp_vms = (mcdc report --format csv) | select -skip 2

Out-File -FilePath .\vms.csv
# CSV fields
#NAME;PLATFORM VM ID;OS;IP;USERNAME;PASSWORD
ForEach ($Line in $tmp_vms) {
    $internal_id, $vm_name, $vm_id, $os_family, $tmp = $Line.Split(",")
 
    $vm = "$vm_name;$vm_id;$os_family;;;"
   
    $vm | Out-File -FilePath .\vms.csv -Append   
}
