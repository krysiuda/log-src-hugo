---
layout: post
title:  "java singleton"
date:   2017-02-28
tags:
- java
- pattern
---

# java singleton pattern #

The basic pattern, which often goes wrong.

## simple implementation ##

Here is a simple singleton implementation I’ve found on wikipedia:

[wiki/Singleton_pattern](https://en.wikipedia.org/wiki/Singleton_pattern)


```java
public final class Singleton {
    private static final Singleton INSTANCE = new Singleton();

    private Singleton() {}

    public static Singleton getInstance() {
        return INSTANCE;
    }
}
```

I will skip the criticism of the pattern usage for now (I hope to address this in a separate post some other time).

The above is a trivial implementation, I see quite often during code reviews. It does exactly what it is supposed to do; but, there are still some gotchas implied with the use of it:
- it is initiated eagly, which is ok in the most cases.
- it is thread safe. The safe initialisation of the static field is guaranteed by the JVM specification.
- it is easy to understand: the ``final`` keyword hints us that the object reference does never change and we do have only one instance of the class.
- the singularity is limited to the scope of a class loader, which is ok in the most cases.

## ugly implementation ##

The wikipedia article provides also a lazy initialised example, which unfortunately I also often see in projects’ codebases:

```java
public final class Singleton {
    private static volatile Singleton instance = null;

    private Singleton() {}

    public static Singleton getInstance() {
        if (instance == null) {
            synchronized(this) {
                if (instance == null) {
                    instance = new Singleton();
                }
            }
        }
        return instance;
    }
}
```

This has rather severe flaws:
- the ``volatile`` keyword is rather (subjective opinion) unknown feature of Java. Without it the above code would be broken, regardless the synchronized block and the two nested if statements; which seems to be confusing developers.
- it was not working on JVMs prior to 5.0 (it could fail under specific conditions) due to a flaw in the JVM specification.
- flow of method returning the instance is complicated, and these who follow strict guidelines (I hope no one really does) on code cleanliness may get stuck wanting to move the three nested blocks (``if``, ``synchronized``, ``if``), which can't really be refactored in any way.
- instance field is not ``final``, which means the static code checking can't help us if we do something wrong with the reference (overwrite it somewhere).

## lazy implementation ##

I always strongly recommend another approach, used already before JVM 5.0, which is a based on how internal classes are loaded by the JVM. This is also covered by an example on wikipedia:

```java
public class Something {
    private Something() {}

    private static class LazyHolder {
        private static final Something INSTANCE = new Something();
    }

    public static Something getInstance() {
        return LazyHolder.INSTANCE;
    }
}
```

This might still seem puzzling, since this implementation is lazy initialised, but that fact is not indicated by anything in the code, besides the structure (and JVM specification).

The trick is in the lack of any static field on the ``Something`` class holding the instance. This allows ``Something`` instances to be initialized, but without initializing the singleton instance immediately. It's when the getInstance method is called the JVM is forced to load LazyHolder class and initialize its static fields containing the singleton instance.

This always seemed to me to be a much cleaner implementation. The only problem I see is that it misses a clear indication that the singleton is intended to be and is loaded lazily.

You may argue that this uses a very specific JVM behaviour, but so is the ``volatile`` keyword. With the inner class we get rid of: synchronization, wrapping ``if`` statements, and our instance field is still ``final`` (immutable reference). All seems less error prone.

At the time I've posted this, the wikipedia articles were available under the following addresses:
- [wiki/Double-checked_locking](https://en.wikipedia.org/wiki/Double-checked_locking)
- [wiki/Initialization-on-demand_holder_idiom](https://en.wikipedia.org/wiki/Initialization-on-demand_holder_idiom)
