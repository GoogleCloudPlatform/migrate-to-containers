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

sudo apt update

# Install MySQL server
sudo apt -y install mysql-server

# Create the petclinic user
sudo mysql -e "CREATE USER 'petclinic'@'%' IDENTIFIED BY 'petclinic';"
# Create a new database for petclinic
sudo mysql -e "CREATE DATABASE petclinic;"
# Grant all for petclinic user on petclinic database
sudo mysql -e "GRANT ALL PRIVILEGES ON petclinic.* TO 'petclinic'@'%' WITH GRANT OPTION;"

sudo sed -i 's/bind-address.*/bind-address = 0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf

sudo systemctl restart mysql
