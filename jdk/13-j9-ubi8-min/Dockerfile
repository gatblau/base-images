#
#    oci-images - Copyright (c) 2018-2019 by www.gatblau.org
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#    Unless required by applicable law or agreed to in writing, software distributed under
#    the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
#    either express or implied.
#    See the License for the specific language governing permissions and limitations under the License.
#
#    Contributors to this project, hereby assign copyright in this code to the project,
#    to be licensed under the same terms as the rest of the code.
#
#    Universal Base Image EULA
#    https://www.redhat.com/licenses/EULA_Red_Hat_Universal_Base_Image_English_20190422.pdf
#
#    AdoptOpenJDK License - https://adoptopenjdk.net/about.html
#
# builder image downloads openjdk on openJ9
FROM alpine as builder

ENV LANG en_GB.UTF-8
ENV JAVA_HOME /usr/java/openjdk-13
ENV PATH $JAVA_HOME/bin:$PATH
ENV JAVA_VERSION 13
ENV JAVA_URL https://github.com/AdoptOpenJDK/openjdk13-binaries/releases/download/jdk-13%2B33_openj9-0.16.0/OpenJDK13U-jre_x64_linux_openj9_13_33_openj9-0.16.0.tar.gz
ENV JAVA_SHA256 2ee59be5062a81daa7be85be161cab6b245f9a2e2cbd4769ae9edefaac41e31d

RUN apk add gzip tar curl && rm -rf /var/cache/apk/*

RUN set -eux; \
	curl -fL -o /openjdk.tgz "$JAVA_URL"; \
	echo "$JAVA_SHA256 */openjdk.tgz" | sha256sum -c -; \
	mkdir -p "$JAVA_HOME"; \
	tar --extract --file /openjdk.tgz --directory "$JAVA_HOME" --strip-components 1; \
	rm /openjdk.tgz;

# no packages are installed on the UBI base image, only the jdk
FROM registry.access.redhat.com/ubi8/ubi-minimal

MAINTAINER gatblau <admin@gatblau.org>
LABEL author="gatblau.org"

ENV LANG en_GB.UTF-8
ENV JAVA_HOME /usr/java/openjdk-13
ENV PATH $JAVA_HOME/bin:$PATH
ENV JAVA_VERSION 13

COPY --from=builder $JAVA_HOME $JAVA_HOME

RUN set -eux; \
    ln -sfT "$JAVA_HOME" /usr/java/default; \
	ln -sfT "$JAVA_HOME" /usr/java/latest; \
	for bin in "$JAVA_HOME/bin/"*; do \
		base="$(basename "$bin")"; \
		[ ! -e "/usr/bin/$base" ]; \
		alternatives --install "/usr/bin/$base" "$base" "$bin" 20000; \
	done; \
	java --version;