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

# Use this version of PetClinic which is still using Spring Boot 2.x.x and doesn't require Java 17
git checkout a5cbb8505a1df3c348c06607933a07fc8c87c222

# Modify the pom.xml to package petclinic application as a war instead of the default jar packaging
sed -i '/<name>petclinic<\/name>/!b;n;c\\t<packaging>war<\/packaging>\n' pom.xml

# Modify the pom.xml to specify the Tomcat dependency as provided because the application will be deployed as a war on an existing Tomcat server
sed -i '/<!-- Spring and Spring Boot dependencies -->/!b;n;c\\t\t<dependency>\n\t\t\t<groupId>org.springframework.boot</groupId>\n\t\t\t<artifactId>spring-boot-starter-tomcat</artifactId>\n\t\t\t<scope>provided</scope>\n\t\t</dependency>\n\t\t<dependency>' pom.xml

# Modify the pom.xml to set the name of the war file
sed -i '0,/<build>/s/<build>/<build>\n\t\t<finalName>petclinic<\/finalName>/' pom.xml

# Modify the main application class to run in a provided Tomcat servlet container
sed -i '/import org.springframework.boot.autoconfigure.SpringBootApplication;/!b;n;cimport org.springframework.boot.web.servlet.support.SpringBootServletInitializer;\n' src/main/java/org/springframework/samples/petclinic/PetClinicApplication.java
sed -i 's/public class PetClinicApplication/public class PetClinicApplication extends SpringBootServletInitializer/g' src/main/java/org/springframework/samples/petclinic/PetClinicApplication.java

# Modify the MySQL server name in application-mysql.properties
sed -i 's/localhost/petclinic-mysql/g' src/main/resources/application-mysql.properties

# Build the application war
./mvnw package -DskipTests=true -Dcheckstyle.skip
