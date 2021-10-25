---
layout: post
title:  "ssh and jump hosts"
date:   2016-08-20
tags:
- ssh
- linux
---

# ssh and jump hosts

Access to machines is often allowed only through a special machine called jump host.
I often find my colleagues puzzled with how to use ssh properly when working in such environment.
Here I list a few possible ways of dealing with it.

## the naive way

We can use ssh port forwarding to access the second machine through the first, like this:

```bash
ssh -L 10022:foo.siuda.net:22 bar.siuda.net # set's up the tunnel to foo.siuda.net through bar.siuda.net
ssh 127.0.0.1:10022 # which connects to foo.siuda.net
```

The result may be seen this way (first is the tunnel, second is the final connection to the foo):

![](ssh1.svg)

While it works, it has a number of issues:

* ssh is creating a small tcp server for you on your local machine (on example above it is the port 10022).
* All traffic going through the ssh tunnel is encrypted, including the already encrypted inner ssh session (in effect it is encrypted twice). This is generally not a big deal, but you should be aware of the extra overhead.
* The overhead gets worse when you need to chain the jump hosts (access another encrypted service from the foo).
* Mind the tcp server used for the tunnel, if it is exposed on your machine (firewall) everyone may use it and forward their tcp connections through your tunnel.
* The setup gets complicated if you need to forward a port further (e.g. access beyondfoo.siuda.net through bar and foo).

## the simple way

For an interactive shell you may use:

```bash
ssh -tt bar.siuda.net ssh -tt foo.siuda.net
```

Which creates:

![](ssh2.svg)

* This makes it easy to go through as many ssh servers as you need, just append more `ssh -tt host`.
* It's equivalent to sshing to bar, and lunching remotely a ssh client to foo.
* You can't forward ports this way.

## the handy way

In the newest version of ssh you may find a shorthand command to use jump hosts (`-J`):

```bash
ssh -J bar.siuda.net ssh foo.siuda.net
```

If it is not available to you (the ssh client is old) you may use:

```bash
ssh -o ProxyCommand=\"ssh -W %h:%p bar.siuda.net\" foo.siuda.net
```

This may be easily combined with port forwarding:

```bash
ssh -o ProxyCommand=\"ssh -W %h:%p bar.siuda.net\" -L 8080:beyondfoo.siuda.net:80 foo.siuda.net
```

## SOCKS proxy, the most handy way

What if you need to access beyondfoo.siuda.net:80 and a number of other hosts/services behind the jump host?
With port forwarding you would need to set up a forwarding port for each of them. But there is a better way:

```bash
ssh -o ProxyCommand=\"ssh -W %h:%p bar.siuda.net\" -D 8080 foo.siuda.net
```

This sets up a simple SOCKS proxy for you. The proxy is able to forward any traffic anywhere further (including beyondfoo.siuda.net:80 if only reachable from foo).

After your connection is estabilished you can set up all your applications to use the proxy, e.g. for java:

```bash
java -DsocksProxyHost=socks.example.com -DsocksProxyPort=8080 -jar util.jar
```

This will make the java application access network through the proxy transparently, and the java app can easly reach beyondfoo.siuda.net:80.
You can also setup your web browser to use the proxy.

![](ssh3.svg)
