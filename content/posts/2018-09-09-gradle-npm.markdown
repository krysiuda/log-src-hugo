---
layout: post
title:  "gradle calling npm"
date:   2018-09-09
tags:
- node.js
- java
- gradle
summary: A quick gradle showoff - automate npm build in 5 seconds without any plugins.
---

# gradle calling npm #

A quick gradle showoff - automate npm build in 5 seconds without any plugins.

## invoke npm ##

The following code (in ``build.gradle``) will extend compilation phase with a call to npm.

```groovy
group 'net.siuda'
version '1.0-SNAPSHOT'

task compile << {
    println 'Calling npm update'
    exec {
        executable 'npm'
        args 'update'
    }
    println 'Calling npm build'
    exec {
        executable 'npm'
        args 'run','build'
    }
}
```

This a quick way to integrate npm build (angular, react.js or any other cool frontend code) with java project.

The call to ``npm update`` helps keeping the local ``node_modules`` excluded from the VCS (git, SVN). If the directory is empty, all artifacts will be downloaded by npm before the build.

Why I call it a showoff? Because it proves how versatile gradle is, maven setup will definitely take more then 10 lines...

Enjoy.
