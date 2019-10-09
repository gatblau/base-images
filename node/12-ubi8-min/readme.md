# Image for Containerised Node Applications

This is an OCI v1 image for running containerised nodejs applications.

It is based on:

- [Red Hat Universal Base Image](https://www.redhat.com/en/blog/introducing-red-hat-universal-base-image) (ubi-minimal): *"OCI-compliant container base operating system image"*
- [NodeJS](https://nodejs.org): *"open-source, cross-platform JavaScript run-time environment that executes JavaScript code server-side"*


## How to use

### Buildah

```bash
# From Quay
openSDK=$(buildah from docker://quay.io/gatblau/node:12-ubi8-min)

# From Docker Hub
openSDK=$(buildah from docker://docker.io/gatblau/node:12-ubi8-min)
```

### Dockerfile

```bash
# From Quay.io
FROM quay.io/gatblau/node:12-ubi8-min

# From Docker hub
FROM docker.io/gatblau/node:12-ubi8-min
```

**NOTE**:

This is not a supported image.

If you need Enterprise supported images you should use [Red Hat Runtimes](https://www.redhat.com/en/products/runtimes).
