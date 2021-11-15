#!/usr/bin/env python3
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

import sys
import subprocess
import time

migrationName = sys.argv[1]
targetOperation = sys.argv[2]


def get_operation(migration):
    """Gets the current operation being executed by the migration"""
    command = ['kubectl', 'get', 'migrations.anthos-migrate.cloud.google.com', '-n', 'v2k-system', migration, '-o',
               'jsonpath={.status.currentOperation}']
    output = subprocess.run(command, capture_output=True, encoding='utf-8')
    output.check_returncode()
    print("Current Operation: ", output.stdout.strip())
    return output.stdout.strip()


def get_status(migration):
    """Gets the current status of the migration"""
    command = ['kubectl', 'get', 'migrations.anthos-migrate.cloud.google.com', '-n', 'v2k-system', migration, '-o',
               'jsonpath={.status.status}']
    output = subprocess.run(command, capture_output=True, encoding='utf-8')
    output.check_returncode()
    print("Current Status: ", output.stdout.strip())
    return output.stdout.strip()


# Add a small buffer
time.sleep(10)

# Wait for the generate operation to begin
operation = get_operation(migrationName)
while operation != targetOperation:
    time.sleep(15)
    operation = get_operation(migrationName)

# Wait for the status to become completed and allow 3 retries if migration goes in to Retrying status
retries = 0
status = get_status(migrationName)
while status != 'Completed':
    if status == 'Running':
        time.sleep(15)
    elif status == 'Retrying':
        if retries == 3:
            exit("Migration reached maximum retries attempts: " + retries)
        retries+=1
        time.sleep(60)
    else:
        exit("Unexpected Migration Status: " + status)
    status = get_status(migrationName)
