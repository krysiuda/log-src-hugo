---
layout: post
title:  "java classpath separation part 1"
date:   2017-12-26
tags:
- classpath
- classloader
- java
- jar
- jar-hell
---

# java classpath separation part 1 #

Setting up a project for classpath (classloader) separation for plain java.

This is a short evaluation on how easy classpath separation can be achived without use of any 3rd party libraries.

Classpath separation allows you to use libraries (`jar` files) which are incompatible and can't be used simultanously.

## rapid introduction to classloading ##

- Java classloader load classes (duh) and resources (e.g. `.properties`).
- Classes may come from files (`.class` files or archives `.jar` `.ear`), remote sources (e.g. files over http), or created dynamically (proxies, think about JPA entities).
- Classloaders implement logic required to load a given resource content and class bytecode.
- JVM provides bootstrap version to load JRE core classes (this one is implemented in native code).
- All other classloaders are implemented in Java.
- Classloaders are hierarchical. Top-most one is the bootstrap one.

## why hierarchy? ##

Let's keep in mind some assumptions first:
- Classloading is expensive. Classes should be cached to accomodate for this; but, we need to try to hit the cache to make it work.
- Classloader can load classes only from a given source. Hence, not every classloader needs to know how to load JRE classes. Let's delegate the loading to the right classloader.
- Most singletons are classloader-wide. The righ classloader should only initialize singleton once.

Typic classloading logic:
1. Delegate loading to the parent classloader.
2. If parent did not load (not found) let's try to load it.

This \"lazy\" logic ensures only additional classes, in scope of our class loader, are loaded using it. All other will share the same, more generic, classloader.

## why to break hierarchy? ##

If we need to have a specialized classloader, which will hide the more general source of classes and substitue them with some specialized versions.

This could work great if we have a part of our application using one version of a library, which breaks rest of the application when added to the classpath.

This also allows us to break scope of singletons (e.g. have two versions of a singleton instance).

## the implementation ##

```java
package net.siuda.clazzes;

import java.net.URL;
import java.net.URLClassLoader;

public class SeparatingClassLoader extends URLClassLoader {

    protected ClassLoader parent;

    public SeparatingClassLoader(URL[] urls, ClassLoader parent) {
        super(urls, parent);
        this.parent = parent;
    }

    public URL getResource(String name) {
        URL url;
        url = findResource(name);
        if(url == null) {
            super.getResource(name);
        }
        return url;
    }

    protected Class<?> loadClass(String name, boolean resolve) throws ClassNotFoundException {
        Class<?> c = findLoadedClass(name);
        if(c == null && canResolve(name)) {
            c = findClass(name);
        }
        if(c == null) {
            c = super.loadClass(name, resolve);
        } else {
            if(resolve) {
                resolveClass(c);
            }
        }
        return c;
    }

    protected boolean canResolve(final String name)
    {
        String path = name.replace('.', '/').concat(".class");
        return findResource(path) != null;
    }

}
```

Later the class needs to be loaded, easiest way to do it is by using reflection:

```java
        ClassLoader cl = new SeparatingClassLoader(urls, this.getClass().getClassLoader());
        Class clazz = cl.loadClass(theClass);
        Object object = clazz.newInstance();
        Method method = clazz.getMethod("run"); // public method on the class
        method.invoke(object);
```

Enjoy.
