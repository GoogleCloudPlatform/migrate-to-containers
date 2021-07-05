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

apt update

apt install -y postgresql postgresql-contrib

sudo -u postgres createdb petclinic

sudo -u postgres psql -U postgres -d petclinic -c "alter user postgres with password 'petclinic';"

echo "listen_addresses = '*'" >> /etc/postgresql/10/main/postgresql.conf

echo "host petclinic postgres 0.0.0.0/0 md5" >> /etc/postgresql/10/main/pg_hba.conf
service postgresql restart
