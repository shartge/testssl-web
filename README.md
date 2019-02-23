Docker Image - testssl-Webfrontend

Project Details: 

This Docker Image is based in the [testssl.sh-webfrontend](https://github.com/TKCERT/testssl.sh-webfrontend) Project from [thyssenkrupp CERT](https://github.com/TKCERT).
The testssl.sh-webfrontend Application uses the [testssl.sh](https://github.com/drwetter/testssl.sh) Script.

```
docker pull shartge/testssl-webfrontend
docker run --rm --name testssl-web -p 5000:5000 shartge/testssl-web
```

