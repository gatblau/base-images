#!/usr/bin/env bash
#
# base-images - Copyright (c) 2020 by www.gatblau.org
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
# Builds the OpenJDK 13 - OpenJ9 JVM container image using buildah.
# Run in CentOS 8 / RHEL 8
#
# NOTE:
#  if running on a buildah version lower than 1.11.3, the run with sudo e.g. sudo bash build.sh $1 $2 $3 $4
#   https://cbs.centos.org/koji/rpminfo?rpmID=171623
#
# check the input variables
if [ $# -lt 4 ]; then
    echo "Parameters provided are not correct. See usage below."
    echo "Usage is: sh build.sh [REPO_NAME] [IMG_NAME] [IMG_TAG] [IMG_FORMAT] - e.g. sh build.sh gatblau opensdk 13-j9-ubi8-min oci"
    exit 1
fi

# input variables
REPO_NAME=$1
IMG_NAME=$2
IMG_TAG=$3
IMG_FORMAT=$4

LANG=en_GB.UTF-8
JAVA_HOME=/usr/java/openjdk-14
PATH=$JAVA_HOME/bin:$PATH
JAVA_VERSION=14
JAVA_JVM_VERSION=openj9-0.19.0
JAVA_URL=https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14%2B36.1_openj9-0.19.0/OpenJDK14U-jdk_x64_linux_openj9_14_36_openj9-0.19.0.tar.gz
JAVA_SHA256=106b72d565be98834ead5fea9555bd646d488a86fc4ae4dd294a38e97bf77509
# UseContainerSupport: prevent the JVM adjusting the maximum heap size when running in a container
# IdleTuningGcOnIdle: when the JVM state is set to idle, it releases free memory pages in the object heap
#   without resizing the Java™ heap and attempts to compact the heap after the garbage collection cycle if
#   certain heuristics are triggered. The pages are reclaimed by the operating system, which reduces the
#   physical memory footprint of the JVM.
JAVA_TOOL_OPTIONS="-XX:+UseContainerSupport -XX:+IdleTuningGcOnIdle"

# create a temporary container to download the jdk
builder=$(buildah from docker://alpine)

# copy the install jdk script in the container
buildah copy $builder downloadJDK.sh /downloadJDK.sh

# install download the jdk
buildah run $builder sh downloadJDK.sh $JAVA_URL $JAVA_SHA256 $JAVA_HOME

# mount the file system of the container
builder_mnt=$(buildah mount $builder)

# create the openjdk working container
target=$(buildah from docker://registry.access.redhat.com/ubi8/ubi-minimal)

# set labels
buildah config --label maintainer="GATBLAU <admin@gatblau.org>" $target
buildah config --label author="gatblau.org>" $target

# set environment variables
buildah config --env LANG=$LANG $target
buildah config --env JAVA_HOME="$JAVA_HOME" $target
buildah config --env PATH="$JAVA_HOME/bin":$PATH $target
buildah config --env JAVA_VERSION="$JAVA_VERSION" $target
buildah config --env JAVA_JVM_VERSION="$JAVA_JVM_VERSION" $target
buildah config --env JAVA_TOOL_OPTIONS="$JAVA_TOOL_OPTIONS" $target

# copy the jdk files
buildah copy $target $builder_mnt$JAVA_HOME $JAVA_HOME

# copy the jdk configuration script
buildah copy $target configureJDK.sh /configureJDK.sh

# run the jdk configuration script
buildah run $target sh configureJDK.sh $JAVA_HOME

# remove the configuration script
buildah run $target rm /configureJDK.sh

# commit the openjdk working container to an image in the local registry
buildah commit --format $IMG_FORMAT $target $REPO_NAME/$IMG_NAME:$IMG_TAG

# tag the local image for docker.io
buildah tag $REPO_NAME/$IMG_NAME:$IMG_TAG docker.io/$REPO_NAME/$IMG_NAME:$IMG_TAG

# tag the local image for quay.io
buildah tag $REPO_NAME/$IMG_NAME:$IMG_TAG quay.io/$REPO_NAME/$IMG_NAME:$IMG_TAG

# remove the localhost tag
buildah rmi localhost/$REPO_NAME/$IMG_NAME:$IMG_TAG

# remove the working containers
buildah rm $builder
