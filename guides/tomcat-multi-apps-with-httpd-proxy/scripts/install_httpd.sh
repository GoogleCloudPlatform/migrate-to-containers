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

apt-get update
apt-get -y install apache2

# Enable proxy modules
a2enmod proxy
a2enmod rewrite
a2enmod proxy_http

# Replace the Apache default site to proxy all requests to local Tomcat
cat << EOF > /etc/apache2/sites-enabled/000-default.conf
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        <Location /petclinic>
                ProxyPass http://127.0.0.1:8080/petclinic
                ProxyPassReverse http://127.0.0.1:8080/petclinic
        </Location>

        <Location /flowcrm>
                ProxyPass http://127.0.0.1:8080/flowcrm
                ProxyPassReverse http://127.0.0.1:8080/flowcrm
        </Location>
        
</VirtualHost>
EOF

# Modify Apache to listen on IPv4
sed -i 's/Listen 80/Listen 0.0.0.0:80/g' /etc/apache2/ports.conf

# Restart Apache service
systemctl restart apache2
