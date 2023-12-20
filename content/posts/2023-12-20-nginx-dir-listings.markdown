---
layout: post
title:  "nginx directory listings cors"
date:   2023-12-20
tags:
- nginx
- json
- cors
summary: nginx can generate directory listings, let's use them from anywhere with CORS
---

# nginx directory listings

I have JavaScript frontend available under ``camera.somewhere.net/``→``/srv/http-camera/``, and ``camera.somewhere.net/storage``→``/mnt/camera/`` containing files, which nginx generates directory listings for. Listings are generated in JSON format, used by JavaScript frontend. However I need the listing to be accessed from another JavaScript frontend, available under a different domain. In order to reuse the same service I need to allow CORS REST call to directory listings. This can easily be done with following configuration extension:

```
server {
  server_name camera.somewhere.net;
  location / {
    root /srv/http-camera/;
  }
  location /storage {
    alias /mnt/camera/;
    autoindex on;
    autoindex_format json;
    if ($request_method ~* "(GET|POST|HEAD)") {
      add_header "Access-Control-Allow-Origin" *;
    }
    if ($request_method = OPTIONS ) {
      add_header "Access-Control-Allow-Origin" *;
      add_header "Access-Control-Allow-Methods" "GET, POST, OPTIONS, HEAD";
      add_header "Access-Control-Allow-Headers" "Authorization, Origin, X-Requested-With, Content-Type, Accept";
      return 200;
    }
  }
}
```

