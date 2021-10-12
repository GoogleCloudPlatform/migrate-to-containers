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
apt-get -y install default-jdk

groupadd tomcat
useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

pwd=$(pwd)

cd /tmp
curl -O https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.65/bin/apache-tomcat-8.5.65.tar.gz

mkdir /opt/tomcat
tar xzvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1

cd /opt/tomcat
chgrp -R tomcat /opt/tomcat

chmod -R g+r conf
chmod g+x conf

chown -R tomcat webapps/ work/ temp/ logs/

if [ $# -eq 1 ]
  then
    sudo chown tomcat:tomcat $pwd/$1
    sudo mv $pwd/$1 /opt/tomcat/webapps/    
fi

# Set spring profile to mysql
sudo echo "spring.profiles.active=mysql" >> /opt/tomcat/conf/catalina.properties

cat << EOF > /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat 8.5 servlet container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/default-java"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"

Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start tomcat
systemctl status tomcat

systemctl enable tomcat
