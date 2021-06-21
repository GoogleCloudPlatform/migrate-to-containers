#!/bin/bash

apt update

apt install -y postgresql postgresql-contrib

sudo -u postgres createdb petclinic

sudo -u postgres psql -U postgres -d petclinic -c "alter user postgres with password 'petclinic';"

echo "listen_addresses = '*'" >> /etc/postgresql/10/main/postgresql.conf

echo "host petclinic postgres 0.0.0.0/0 md5" >> /etc/postgresql/10/main/pg_hba.conf
service postgresql restart
