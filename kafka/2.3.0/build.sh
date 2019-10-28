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
# Builds the OpenJDK 13 - OpenJ9 JVM OCI image using buildah.
# Run in CentOS 8 / RHEL 8
#
# NOTE:
#  if running on a buildah version lower than 1.11.3, the run with sudo e.g. sudo bash build.sh $1 $2 $3 $4
#   https://cbs.centos.org/koji/rpminfo?rpmID=171623
#
# check the input variables
if [ $# -lt 4 ]; then
    echo "Parameters provided are not correct. See usage below."
    echo "Usage is: sh build.sh [REPO_NAME] [IMG_NAME] [IMG_TAG] [IMG_FORMAT] - e.g. sh build.sh gatblau kafka 2.3.0 oci"
    exit 1
fi
# input variables
REPO_NAME=$1
IMG_NAME=$2
IMG_TAG=$3
IMG_FORMAT=$4

LANG=en_GB.UTF-8
KAFKA_VERSION=2.12-2.3.0
KAFKA_URL=http://apache.mirror.anlx.net/kafka/2.3.0/kafka_2.12-2.3.0.tgz
KAFKA_SHA256=d86f5121a9f0c44477ae6b6f235daecc3f04ecb7bf98596fd91f402336eee3e7
KAFKA_HOME=/opt/kafka

# create a temporary container to download the jdk
builder=$(buildah from docker://alpine)

# copy the install jdk script in the container
buildah copy $builder downloadKafka.sh /downloadKafka.sh

# install download the jdk
buildah run $builder sh downloadKafka.sh $KAFKA_URL $KAFKA_SHA256 $KAFKA_HOME

# mount the file system of the container
builder_mnt=$(buildah mount $builder)

# create the openjdk working container
target=$(buildah from docker://quay.io/gatblau/openjdk:13-j9-ubi8-min)

# set labels
buildah config --label maintainer="GATBLAU <admin@gatblau.org>" $target
buildah config --label author="gatblau.org" $target

# set environment variables
buildah config --env LANG=$LANG $target
buildah config --env KAFKA_HOME=$KAFKA_HOME $target
buildah config --env PATH=$KAFKA_HOME/bin:$PATH $target
buildah config --env KAFKA_VERSION=$KAFKA_VERSION $target

# copy the kafka files
buildah copy $target $builder_mnt$KAFKA_HOME $KAFKA_HOME

# switch to the root user
buildah config --user root $target

# install netcat
buildah run $target rpm -vhU https://nmap.org/dist/ncat-7.80-1.x86_64.rpm

# copy scripts
buildah copy $target start.sh /start.sh
buildah copy $target server.properties $KAFKA_HOME/config/server.properties

# make user 20 own the kafka & /run directories
buildah run $target chown -R 20 $KAFKA_HOME
buildah run $target chown -R 20 /run

# set the user the container processes run under
buildah config --user 20 $target

# expose the required ports
buildah config --port 9092 $target # kafka port
buildah config --port 2181 $target # zookeeper port

buildah config --cmd "sh start.sh" $target

# commit the container to an image in the local registry
buildah commit --format $IMG_FORMAT $target $REPO_NAME/$IMG_NAME:$IMG_TAG

# tag the local image for docker.io
buildah tag $REPO_NAME/$IMG_NAME:$IMG_TAG docker.io/$REPO_NAME/$IMG_NAME:$IMG_TAG

# tag the local image for quay.io
buildah tag $REPO_NAME/$IMG_NAME:$IMG_TAG quay.io/$REPO_NAME/$IMG_NAME:$IMG_TAG

# remove the localhost tag
buildah rmi localhost/$REPO_NAME/$IMG_NAME:$IMG_TAG

# remove the working containers
buildah rm $builder
