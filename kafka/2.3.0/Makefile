#
#    base-images - Copyright (c) 2019 by www.gatblau.org
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
REPO_NAME=gatblau
IMG_NAME=kafka
IMG_TAG = 2.3.0

# builds an docker v2 schema v2 image
image:
	sudo bash build.sh $(REPO_NAME) $(IMG_NAME) $(IMG_TAG) docker

# builds an OCI v1 image
oci-image:
	sudo bash build.sh $(REPO_NAME) $(IMG_NAME) $(IMG_TAG) oci

# push image to docker.io
push:
	sudo podman login docker.io -u gatblau
	sudo podman push docker.io/$(REPO_NAME)/$(IMG_NAME):$(IMG_TAG)

# push image to quay.io
push-quay:
	sudo podman login quay.io -u gatblau
	sudo podman push quay.io/$(REPO_NAME)/$(IMG_NAME):$(IMG_TAG)
