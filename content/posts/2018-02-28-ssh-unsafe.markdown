---
layout: post
title:  "ssh host id: connect to a unknown host"
date:   2018-02-28
tags:
- ssh
---

# ssh host id #

A quick tip to make your ssh not complain with messages like this one: ``WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!``.

SSH can use the same public and private key pairs and the same cryptography functions as used in TLS/PKI; but, usually it does not (this is OpenSSH, there are exceptions out there). The lack of PKI results in no generic way to verify server identity and prevent man in middle type of attacks. SSH connecting to a host for the first time stores server's ID in the ``known_hosts``. The ID is later verified, when connection is established for the second time. If the verification fails SSH client displays ``WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!`` and refuses to connect. In such case you might need to remove the ID entry from the ``known_hosts``.

If your often connect to hosts for the first time, and you never plan to connect to them again, consider disabling this feature. This will help you keep your ``known_hosts`` file clean, and prevent the annoying messages.

As a remedy, you can use the following command line:

```bash
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no foo.siuda.net
```

this way SSH will not try to verify server's identity. This does introduce a security vulnerability; but, it is fine if you never plan to reconnect.
