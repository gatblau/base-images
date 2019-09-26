#
#    base-images - Copyright (c) 2018-2019 by www.gatblau.org
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
FROM alpine as builder

ENV LANG en_GB.UTF-8
ENV NODE_HOME /usr/node/12.11.0
ENV NODE_URL https://nodejs.org/dist/v12.11.0/node-v12.11.0-linux-x64.tar.xz

RUN apk add gzip tar xz curl && rm -rf /var/cache/apk/*; \
    set -eux; \
	curl -fL -o /node.tgz "$NODE_URL"; \
    mkdir -p "$NODE_HOME"; \
	tar --extract --file /node.tgz --directory "$NODE_HOME" --strip-components 1; \
	rm /node.tgz;

# no packages are installed on the UBI base image, only node binaries
FROM registry.access.redhat.com/ubi8/ubi-minimal

MAINTAINER gatblau <admin@gatblau.org>
LABEL author="gatblau.org"

ENV LANG en_GB.UTF-8
ENV NODE_VERSION 12.11.0
ENV NODE_URL https://nodejs.org/dist/v12.11.0/node-v12.11.0-linux-x64.tar.xz
ENV NODE_HOME /usr/node/12.11.0

COPY --from=builder $NODE_HOME $NODE_HOME

RUN set -eux; \
    ln -sfT "$NODE_HOME" /usr/node/default; \
	ln -sfT "$NODE_HOME" /usr/node/latest; \
	for bin in "$NODE_HOME/bin/"*; do \
		base="$(basename "$bin")"; \
		[ ! -e "/usr/bin/$base" ]; \
		alternatives --install "/usr/bin/$base" "$base" "$bin" 20000; \
	done; \
	node --version;