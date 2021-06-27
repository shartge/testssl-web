# Docker Image - testssl-Webfrontend

## Project Details

This Docker Image is is a fork of [mycloudrevolution/testssl-webfrontend](https://github.com/mycloudrevolution/testssl-webfrontend) from Markus Kraus
based on the [testssl.sh-webfrontend](https://github.com/TKCERT/testssl.sh-webfrontend) Project from [thyssenkrupp CERT](https://github.com/TKCERT).
The testssl.sh-web Application uses the [testssl.sh](https://github.com/drwetter/testssl.sh) Script from Dirk Wetter.

```
docker pull ghcr.io/shartge/testssl-web
docker run --rm --name testssl-web -p 5000:5000 ghcr.io/shartge/testssl-web
```

## Configuration

### Number of concurrent SSL tests

You can configure the number of uWSGI processes and threads inside the container via the variables `UWSGI_PROCESSES` and `UWSGI_THREADS`. Both control how many SSL tests can be run concurrently.

Example:

```
docker run --rm --name testssl-web -e UWSGI_THREADS=8 -e UWSGI_PROCESSES=2 -p 5000:5000 ghcr.io/shartge/testssl-web
```

### Setting the timeout

You can configure the timeout for each test by setting the variable `TEST_TIMEOUT`.

Example:

```
docker run --rm --name testssl-web -e TEST_TIMEOUT=600 -p 5000:5000 hartge/testssl-web
```

### Enabling debugging

You can enable testssl.sh debugging by setting the variable `TESTSSLDEBUG`.
Values from 0 (no debugging, default) to 6 (maxiumim debuggin) are possible
I recommends to also increase `TEST_TIMEOUT` to at lease 600 when debugging.

Example:

```
docker run --rm --name testssl-web -e TESTSSLDEBUG=2 -p 5000:5000 hartge/testssl-web
```

### Integration into external Nginx

If you want to use testssl-web behind a Nginx proxy, you need to make sure to disable `proxy_buffering` or otherwise the streaming updates during the running test will not appear.

Example:

```
location /testssl {
    proxy_pass       http://localhost:5000;
    proxy_set_header Host      $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_buffering  off;
}
```

