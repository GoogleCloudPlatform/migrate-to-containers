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

if [ -z "$1" ]
  then
    echo "Input CSV file NOT supplied"
    exit
fi
if [ -z "$2" ]
  then
    echo "Output prefix not supplied"
    exit
fi
num_of_lines=$3
if [ -z "$3" ]
  then
    echo "Split files size not supplied. Defaulting to 10 lines per file."
    num_of_lines=10
fi

# [START split]
tail -n +2 $1 | split -d -l $num_of_lines - $2
for file in $2*
do
    head -n 1 $1 > tmp_file
    cat "$file" >> tmp_file
    mv -f tmp_file "$file"
done
# [END split]