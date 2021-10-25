---
layout: post
title:  "java classpath separation part 2"
date:   2018-01-08
tags:
- java
- classpath
- classloader
- jar
- jar-hell
---

# java classpath separation part 2 #

A demo project for classpath (classloader) separation for plain java.

This is a continuation of [part 1](posts/2017/12/26/), where I have briefly described the concept.

## about the demo ##

The demo consists of two projects: ``ClazzLoad``, and additional internal one ``Separated``. Both are build with a single [gradle](https://gradle.org/) build script. The latter project has a simple dependency on a ``jar`` library, which is not compatible with the main project. 

## what's inside ##

This is the separated, internal project. It is using the [``com.google.common.net.HostAndPort.fromParts(String, int)``](http://google.github.io/guava/releases/14.0.1/api/docs/com/google/common/net/HostAndPort.html#fromParts(java.lang.String, int)) from guava ``14.0.1``, removed from more recent guava releases. This code cannot compile nor run against guava ``17.0``.

```java
package net.siuda.clazzes.separated;

import com.google.common.net.HostAndPort;

public class Separated {

    public void run() {
        System.out.println(\"RUN!\");
        HostAndPort hostAndPort = HostAndPort.fromParts(\"localhost\", 8080);
        System.out.println(\"result:\" + hostAndPort.getHostText());
    }

}
```

This is the program entry-point creating the ``SeparatingClassLoader`` for a list of ``.jar`` files' URLs (poinitng to the ``Separated`` project and it's dependencies).

After invocation of ``Separated`` code it calls [``com.google.common.net.HostAndPort.fromHost(String)``](http://google.github.io/guava/releases/23.6-jre/api/docs/com/google/common/net/HostAndPort.html#fromHost-java.lang.String-) which was added in guava ``17.0`` and would fail with older releases. This code cannot compile nor run against guava ``14.0.1``.

```java
package net.siuda.clazzes;

import com.google.common.net.HostAndPort;

import java.lang.reflect.Method;
import java.net.URL;

public class Main {

    private URL[] urls;

    public static void main(String ... args) throws Exception {
        URL[] urls = new URL[args.length];
        for(int c = 0; c < args.length; c++) {
            urls[c] = new URL(args[c]);
        }
        new Main(urls).run();
    }

    private Main(URL[] urls) {
        this.urls = urls;
    }

    private void run() throws Exception {
        ClassLoader cl = new SeparatingClassLoader(urls, this.getClass().getClassLoader());
        Class clazz = cl.loadClass(\"net.siuda.clazzes.separated.Separated\");
        Object object = clazz.newInstance();
        Method method = clazz.getMethod(\"run\");
        method.invoke(object);

        System.out.println(\"CONTINUE PARENT RUN:\");
        HostAndPort hostAndPort = HostAndPort.fromHost(\"localhost\");
        System.out.println(\"result:\" + hostAndPort.getHost());
    }

}
```

## running the demo ##

```bash
[ClazzLoad]$ gradle jar
Starting a Gradle Daemon, 1 incompatible and 1 stopped Daemons could not be reused, use --status for details
:compileJavaNote: /mnt/drive/wlochaty/GIT/log/2017/java-classpathseparation/ClazzLoad/src/main/java/net/siuda/clazzes/Main.java uses unchecked or unsafe operations.
Note: Recompile with -Xlint:unchecked for details.

:processResources NO-SOURCE
:classes
:jar
:Separated:compileJava
:Separated:processResources NO-SOURCE
:Separated:classes
:Separated:jar

BUILD SUCCESSFUL in 11s
4 actionable tasks: 4 executed

[ClazzLoad]$ java -classpath file:///home/wlochaty/.gradle/caches/modules-2/files-2.1/com.google.guava/guava/23.5-jre/e9ce4989adf6092a3dab6152860e93d989e8cf88/guava-23.5-jre.jar:build/libs/ClazzLoad-1.0-SNAPSHOT.jar net.siuda.clazzes.Main file:///home/wlochaty/h/IdeaProjects/ClazzLoad/Separated/build/libs/Separated-1.0-SNAPSHOT.jar file:///home/wlochaty/.gradle/caches/modules-2/files-2.1/com.google.guava/guava/14.0.1/69e12f4c6aeac392555f1ea86fab82b5e5e31ad4/guava-14.0.1.jar 
RUN!
result:localhost
CONTINUE PARENT RUN:
result:localhost
[wlochaty@desklamp ClazzLoad]$ 
```

After the building jars with gradle I invoke the program with:
- ``java``
- classpath for the main project: guava-23.5-jre and ClazzLoad-1.0-SNAPSHOT: ``-classpath file:///home/wlochaty/.gradle/caches/modules-2/files-2.1/com.google.guava/guava/23.5-jre/e9ce4989adf6092a3dab6152860e93d989e8cf88/guava-23.5-jre.jar:build/libs/ClazzLoad-1.0-SNAPSHOT.jar``.
- main class ``net.siuda.clazzes.Main``
- program arguments, which is a list of classpath URLs to be used by the separated classloader: guava-14.0.1 and Separated-1.0-SNAPSHOT: ``file:///home/wlochaty/h/IdeaProjects/ClazzLoad/Separated/build/libs/Separated-1.0-SNAPSHOT.jar file:///home/wlochaty/.gradle/caches/modules-2/files-2.1/com.google.guava/guava/14.0.1/69e12f4c6aeac392555f1ea86fab82b5e5e31ad4/guava-14.0.1.jar``

(note: for simplicity I've used paths to jars from gradle cache, the paths may need to be changed to run on your machine)

Enjoy.
