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
IMG_NAME=mosquitto
IMG_TAG = 1.6.10-1 # mosquitto version

run:
	docker run --name oxmsg -it -d -p 1883:1883 -e ALLOW_ANONYMOUS=false $(REPO_NAME)/$(IMG_NAME):$(IMG_TAG)

image:
	docker build -t $(REPO_NAME)/$(IMG_NAME):v$(IMG_TAG) --build-arg VERSION=$(IMG_TAG) --no-cache .
	docker tag $(REPO_NAME)/$(IMG_NAME):v$(IMG_TAG) $(REPO_NAME)/$(IMG_NAME):latest

push:
	docker push $(REPO_NAME)/$(IMG_NAME):v$(IMG_TAG)

clean:
	#docker kill $(docker ps -q)
	#docker rm $(docker ps --filter=status=exited --filter=status=created -q)
	docker rmi $(docker images -a -q)