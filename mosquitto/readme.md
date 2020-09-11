# Mosquitto MQTT Broker

Docker image base on [Red Hat Universal Base Image](https://developers.redhat.com/products/rhel/ubi) which includes parameterisation of authentication credentials using environment variables.

## Configuration

| variable | description | default |
|---|---|---|
|**ALLOW_ANONYMOUS** | allow anonymous access | true |
|**PASSWORD_FILE** | location of the password file | /app/pwd.txt |
|**PASSWORD** | the password for the user "mosquitto" | - |

# Usage

## Authenticated access

```shell script
$ docker run --name mosquitto -it -d \
      -p 1883:1883 \
      -e ALLOW_ANONYMOUS=false
      -e PASSWORD="M0squ1tt0mqtt"
      gatblau/mosquito
```

## Anonymous access

```shell script
$ docker run --name mosquitto -it -d \
      -p 1883:1883 \
      gatblau/mosquito
```

## Relevant Links

| name | description |
|---|---|
| [BOOT](https://github.com/gatblau/boot) | Utility to merge environment variables |
| [Dockerfile](https://github.com/gatblau/base-images/mosquitto) | location of image build scripts |

