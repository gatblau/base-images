# Image for Containerised Node Applications

This image is for running containerised nodejs applications.

It is based on:

- [Red Hat Universal Base Image](https://www.redhat.com/en/blog/introducing-red-hat-universal-base-image) (ubi-minimal): *"OCI-compliant container base operating system image"*
- [NodeJS](https://nodejs.org): *"open-source, cross-platform JavaScript run-time environment that executes JavaScript code server-side"*


## How to use

```dockerfile
# Dockerfile
FROM quay.io/gatblau/node:12-ubi8-min
...
```

