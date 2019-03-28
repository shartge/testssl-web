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

### Setting the timeout

You can configure the timeout for each test by setting the variable `TEST_TIMEOUT`.

Example:

```
docker run --rm --name testssl-web -e TEST_TIMEOUT=300 -p 5000:5000 hartge/testssl-web
```

