#
#    base-images - Copyright (c) 2019-2020 by www.gatblau.org
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
IMG_NAME=openjdk
IMG_TAG_13 = 13-j9-ubi8-min
IMG_TAG_14 = 14-j9-ubi8-min

# builds an docker v2 schema v2 image
image-13:
	sudo bash build_13.sh $(REPO_NAME) $(IMG_NAME) $(IMG_TAG_13) docker

# builds an OCI v1 image
oci-image-13:
	sudo bash build_13.sh $(REPO_NAME) $(IMG_NAME) $(IMG_TAG_13) oci

push-13:
	sudo podman login docker.io -u gatblau
	sudo podman push docker.io/$(REPO_NAME)/$(IMG_NAME):$(IMG_TAG_13)

push-quay-13:
	sudo podman login quay.io -u gatblau
	sudo podman push quay.io/$(REPO_NAME)/$(IMG_NAME):$(IMG_TAG_13)

# builds an docker v2 schema v2 image
image-14:
	sudo bash build_14.sh $(REPO_NAME) $(IMG_NAME) $(IMG_TAG_14) docker

# builds an OCI v1 image
oci-image-14:
	sudo bash build_14.sh $(REPO_NAME) $(IMG_NAME) $(IMG_TAG_14) oci

push-14:
	sudo podman login docker.io -u gatblau
	sudo podman push docker.io/$(REPO_NAME)/$(IMG_NAME):$(IMG_TAG_14)

push-quay-14:
	sudo podman login quay.io -u gatblau
	sudo podman push quay.io/$(REPO_NAME)/$(IMG_NAME):$(IMG_TAG_14)
