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

# the name of the container registry repository
REPO_NAME=quay.io/gatblau
IMG_NAME=node
IMG_TAG = 12-ubi8-min

# get old images that are left without a name from new image builds (i.e. dangling images)
DANGLING_IMS = $(shell docker images -f dangling=true -q)

image:
	docker build -t $(REPO_NAME)/$(IMG_NAME):$(IMG_TAG) .

push:
	docker push $(REPO_NAME)/$(IMG_NAME):$(IMG_TAG)

# deletes dangling images
clean:
	docker rmi $(DANGLING_IMS) -f