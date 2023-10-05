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
handle_windows () {
	echo "skipping Windows instance $1"
}

handle_linux () {
	echo "handle Linux instance $1 STATUS $3"

	if [[ $3 == "RUNNING" ]]; then
	    gcloud compute ssh $1 --zone $2 --tunnel-through-iap --command="curl -O "https://mcdc-release.storage.googleapis.com/$(curl -s https://mcdc-release.storage.googleapis.com/latest)/mcdc-linux-collect.sh";chmod +x mcdc-linux-collect.sh;sudo ./mcdc-linux-collect.sh"

	    gcloud compute scp $1:m4a-collect-* guest_data/. --zone $2 --tunnel-through-iap
	fi
}

import_guest_data () {
	./mcdc discover import guest_data/m4a-collect*
}

mkdir guest_data

for vms in $(
    gcloud compute instances list \
	    --format="csv[no-heading](name,zone,disks[0].licenses,status)" --filter="name!~'^(gke|gk3)'")
do
      IFS=',' read -r -a vmsArray<<< "$vms"
      NAME="${vmsArray[0]}"
      ZONE="${vmsArray[1]}"
      LICENSE="${vmsArray[2]}"
      STATUS="${vmsArray[3]}"

      if [[ $LICENSE == *"windows"* ]]; then
          handle_windows $NAME
       else
	  handle_linux $NAME $ZONE $STATUS
      fi
#      echo "NAME: $NAME, ZONE: $ZONE, LICENSE: $LICENSE"
#      echo ""
done

import_guest_data