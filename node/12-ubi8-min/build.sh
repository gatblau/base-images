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
# Builds the NodeJS image using buildah.
# Run in CentOS 8 / RHEL 8
#
# NOTE:
#  if running on a buildah version lower than 1.11.3, the run with sudo e.g. sudo bash build.sh $1 $2 $3 $4
#   https://cbs.centos.org/koji/rpminfo?rpmID=171623
#
# check the input variables
if [ $# -lt 3 ]; then
    echo "Parameters provided are not correct. See usage below."
    echo "Usage is: sh build.sh [REPO_NAME] [IMG_NAME] [IMG_TAG] - e.g. sh build.sh gatblau opensdk 13-j9-ubi8-min"
    exit 1
fi
# input variables
REPO_NAME=$1
IMG_NAME=$2
IMG_TAG=$3

LANG=en_GB.UTF-8
NODE_HOME=/usr/node/12.11.0
NODE_URL=https://nodejs.org/dist/v12.11.0/node-v12.11.0-linux-x64.tar.xz
NODE_VERSION=12.11.0

# create a temporary container to download nodejs
builder=$(buildah from docker://alpine)

# copy the install download node script to the container
buildah copy $builder downloadNode.sh /downloadNode.sh

# run download script
buildah run $builder sh downloadNode.sh $NODE_URL $NODE_HOME

# mount the file system of the container
builder_mnt=$(buildah mount $builder)

# create the node working container
target=$(buildah from docker://registry.access.redhat.com/ubi8/ubi-minimal)

# set labels
buildah config --label maintainer="GATBLAU <admin@gatblau.org>" $target
buildah config --label author="gatblau.org>" $target

# set environment variables
buildah config --env LANG=$LANG $target
buildah config --env NODE_VERSION=$NODE_VERSION $target
buildah config --env NODE_URL=$NODE_URL $target
buildah config --env NODE_HOME=$NODE_HOME $target

# copy the node files
buildah copy $target $builder_mnt$NODE_HOME $NODE_HOME

# copy the node configuration script
buildah copy $target configureNode.sh /configureNode.sh

# run the node configuration script
buildah run $target sh configureNode.sh $NODE_HOME

# remove the configuration script
buildah run $target rm /configureNode.sh

# commit the openjdk working container to an image in the local registry
buildah commit --format oci $target $REPO_NAME/$IMG_NAME:$IMG_TAG

# tag the local image for docker.io
buildah tag $REPO_NAME/$IMG_NAME:$IMG_TAG docker.io/$REPO_NAME/$IMG_NAME:$IMG_TAG

# tag the local image for quay.io
buildah tag $REPO_NAME/$IMG_NAME:$IMG_TAG quay.io/$REPO_NAME/$IMG_NAME:$IMG_TAG

# remove the localhost tag
buildah rmi localhost/$REPO_NAME/$IMG_NAME:$IMG_TAG

# remove the working containers
buildah rm $builder
buildah rm $target
