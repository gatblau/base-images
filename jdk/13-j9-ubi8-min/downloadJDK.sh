#!/usr/bin/env bash
#
# base-images - Copyright (c) 2019 by www.gatblau.org
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software distributed under
# the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
# either express or implied.
# See the License for the specific language governing permissions and limitations under the License.
#
# Contributors to this project, hereby assign copyright in this code to the project,
# to be licensed under the same terms as the rest of the code.
#
JAVA_URL=$1
JAVA_SHA256=$2
JAVA_HOME=$3

apk add gzip tar curl
rm -rf /var/cache/apk/*

set -eux;
curl -fL -o /openjdk.tgz "$JAVA_URL"
echo "$JAVA_SHA256 */openjdk.tgz" | sha256sum -c -
mkdir -p "$JAVA_HOME"
tar --extract --file /openjdk.tgz --directory "$JAVA_HOME" --strip-components 1
rm /openjdk.tgz
