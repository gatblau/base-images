# Image for Containerised Java Applications

This is an OCI v1 image for running performant containerised java applications.

It is based on:

- [Red Hat Universal Base Image](https://www.redhat.com/en/blog/introducing-red-hat-universal-base-image) (ubi-minimal): *"OCI-compliant container base operating system image"*
- [Eclipse OpenJ9 JVM](https://www.eclipse.org/openj9/): *"low memory footprint, fast startup time, high application throughput, smoother ramp up in the cloud"*
- [OpenJDK](https://openjdk.java.net/)

## How to use

### Buildah

```bash
# From Quay
openSDK=$(buildah from docker://quay.io/gatblau/openjdk:13-j9-ubi8-min)

# From Docker Hub
openSDK=$(buildah from docker://docker.io/gatblau/openjdk:13-j9-ubi8-min)
```

### Dockerfile

```bash
# From Quay.io
FROM quay.io/gatblau/openjdk:13-j9-ubi8-min

# From Docker hub
FROM docker.io/gatblau/openjdk:13-j9-ubi8-min
```

**NOTE**:
This is not a supported image.
If you need Enterprise supported images you should use [Red Hat Runtimes](https://www.redhat.com/en/products/runtimes).

### Tags and Versions

| Tag | OpenJ9 | JDK | OS |
|---|---|---|---|
| 13-j9-ubi8-min | openj9-0.16.0 | JDK_13_33 | UBI 8 |
| 14-j9-ubi8-min | openj9-0.19.0 | JDK_14_36 | UBI 8 |