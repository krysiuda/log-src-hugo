---
layout: post
title:  "ssh keep session alive"
date:   2016-10-18
tags:
- ssh
---

# ssh keepalive #

A quick tip to make your ssh session last even when inactive.

If your ssh sessions seem to freeze and eventually you see a ``Connection reset by xxx.xxx.xxx.xxx port xx`` error message, consider a change in your ssh config.

From the command line:

```bash
ssh -o ServerAliveInterval=60 foo.siuda.net
```

or add the config below to your ``.ssh/config``:
```
Host foo
     HostName foo.siuda.net
     User me
     ServerAliveInterval 60
```
