# Image for Containerised Java Applications

This image is for running performant containerised java applications.

It is based on:

- [Red Hat Universal Base Image](https://www.redhat.com/en/blog/introducing-red-hat-universal-base-image) (ubi-minimal): *"OCI-compliant container base operating system image"*
- [Eclipse OpenJ9 JVM](https://www.eclipse.org/openj9/): *"low memory footprint, fast startup time, high application throughput, smoother ramp up in the cloud"*
- [OpenJDK](https://openjdk.java.net/)


## How to use

```dockerfile
# Dockerfile
FROM quay.io/gatblau/openjdk:13-j9jdk-ubi8-min
...

```

