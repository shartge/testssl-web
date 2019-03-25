# Docker Image - testssl-Webfrontend

## Project Details

This Docker Image is based in the [testssl.sh-webfrontend](https://github.com/TKCERT/testssl.sh-webfrontend) Project from [thyssenkrupp CERT](https://github.com/TKCERT).
The testssl.sh-webfrontend Application uses the [testssl.sh](https://github.com/drwetter/testssl.sh) Script.

```
docker pull hartge/testssl-web
docker run --rm --name testssl-web -p 5000:5000 hartge/testssl-web
```

## Configuration

### Number of concurrent SSL tests

You can configure the number of uWSGI processes and threads inside the container via the variables `UWSGI_PROCESSES` and `UWSGI_THREADS`. Both control how many SSL tests can be run concurrently.

Example:

```
docker run --rm --name testssl-web -e UWSGI_THREADS=8 -e UWSGI_PROCESSES=2 -p 5000:5000 hartge/testssl-web
```

### Result data

The output of the `testssl.sh` script is the directory `/testssl/output`, exported as docker volume.

Because the amount of data inside it can grow large over time, it is advised to attach the volume to an external directory and run a cleanup job from time to time.

```
docker run --rm --name testssl-web -v /var/log/testssl:/testssl/output -p 5000:5000 hartge/testssl-web
```

### Mapping the internal user to external user

In the default configuration the uWSGI process inside the container runs as `nobody:nogroup`. You can change this via the variables `LOCAL_UID` and `LOCAL_GID`.

Note: The `uid:gid` `0:0` is always changed to `65534:65534` for security reasons.

```
docker run --rm --name testssl-web -e LOCAL_UID=1001 -e LOCAL_GID=1000 -p 5000:5000 hartge/testssl-web

```

