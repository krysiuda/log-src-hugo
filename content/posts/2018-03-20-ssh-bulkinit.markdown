---
layout: post
title:  "ssh bulk initialize authorized keys on spawned VMs"
date:   2018-03-20
tags:
- ssh
---

# authorized keys bulk set up #

This is a simple bash one-liner distributing local public key to ``authorized_keys`` on multiple target machines.

While using SSH to access remote (virtual) machines, it's great to use keys instead of passwords.

I often receive a long list of newly created machines. It is hard to track all passwords on the new machines, so I prefer to switch to keys the first day I start using them. This still requires typing in all the passwords, but this is done only once.

The following command line iterates over a set of machines IPs, adds them to known hosts, prompts for the password and installs the public key (so the password will not be used for next logins).

```bash
for i in 11 12 13 14 15 ; do cat ~/.ssh/id_rsa.pub | ssh 10.0.0.$i \"mkdir .ssh ; cat > .ssh/authorized_keys ; chmod -R go-rwx .ssh\" ; done
```

The script writes the current user's public key to a new remote ``authorized_keys`` file, and sets it's file permissions accordingly.
