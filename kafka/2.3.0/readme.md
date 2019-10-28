# Image for Single Container Apache Kafka

This is an OCI v1 image for running Apache Kafka in a single container.
Only suitable for development purposes.

It is based on:

- [Red Hat Universal Base Image](https://www.redhat.com/en/blog/introducing-red-hat-universal-base-image) (ubi-minimal): *"OCI-compliant container base operating system image"*
- [Eclipse OpenJ9 JVM](https://www.eclipse.org/openj9/): *"low memory footprint, fast startup time, high application throughput, smoother ramp up in the cloud"*
- [OpenJDK](https://openjdk.java.net/)
- [Apache Kafka](https://www.apache.org/dyn/closer.cgi?path=/kafka/2.3.0/kafka_2.12-2.3.0.tgz)

## How to use

```bash
docker network create --subnet=172.18.0.0/16 kafka 
docker run --name kafka --net kafka --ip 172.18.0.22 -p 9092:9092 -p 2181:2181 -d --env KAFKA_CREATE_TOPICS="k8s:1:1" --env ADVERTISED_HOST=172.18.0.22 --env ADVERTISED_PORT=9092 docker.io/gatblau/kafka:2.3.0

# or

podman run --name kafka -p 9092:9092 -p 2181:2181 -d quay.io/gatblau/kafka:2.3.0
```

**NOTE**:
This is not a supported image.
If you need Enterprise supported images you should use [Red Hat Runtimes](https://www.redhat.com/en/products/runtimes).


