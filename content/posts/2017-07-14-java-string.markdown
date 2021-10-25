---
layout: post
title:  "java string mutable"
date:   2017-07-14
tags:
- java
- broken
- string
---

# java string mutable #

Java strings are slow.

## first steps in java ##

I remember how surprised I was putting my first steps in Java.
Why would simple objects have enforced immutability?
String was an example representing basically a simple array of characters, which I would be used to modify
(note: that's not completely true, since it is using UTF-16, which can encode some characters with more than a single char).

After some reading, back in the days, I found out how the strings are neatly mangled to use a common pool of character sequence (``String.intern()``) and how all objects representing primitives, like Long, are immutable. It all started to seem well justified with a OOD keept in mind.

## performance ##

However recently I had a need to make a trivial substitution of characters in a string. Taking performance as an important factor, I begun questioning the Java principles again.

I've found out the Java implementation of ``String.replace`` is implemented by calling ``RexExp``. I believe​ to understand author, who wanted to reuse existing code, but I can't believe that all this would be done without significant impact on performance. There an idea raised to actually try and measure the performance impact.

I've made a simple class holding an array of characters internally and providing similar functionality to replace substrings in the array. I wanted to make the class fairly usable, so I thought about conversion between it and java ``Strings`` as well some basic methods to work with the data.

## implementation ##

```java
package net.siuda.quickstring;

public class QuickStringWithCollectionOpt {

    // the char array itself
    char [] array;

    // a set of constructors initializing the array

    public static QuickStringWithCollectionOpt empty() {
        QuickStringWithCollectionOpt result = new QuickStringWithCollectionOpt();
        result.array = new char[] {};
        return result;
    }

    public static QuickStringWithCollectionOpt valueOf(String source) {
        QuickStringWithCollectionOpt result = new QuickStringWithCollectionOpt();
        result.array = source.toCharArray();
        return result;
    }

    // conversion to java.String

    public String toString() {
        return String.valueOf(array);
    }

    // the replace function taking java.String arguments

    public QuickStringWithCollectionOpt replace(String what, String with) {
        return replace(valueOf(what), valueOf(with));
    }

    // the real replace implementation

    public QuickStringWithCollectionOpt replace(QuickStringWithCollectionOpt what, QuickStringWithCollectionOpt with) {
        // pass 1 : find all matching substrings
        QuickIntList indexArray = new QuickIntList();
        for(int c = 0; c < (array.length - what.array.length); c++) {
            int same = 0;
            for(int d = 0; (d < what.array.length) && (array[c + d] == what.array[d]); d++) {
                same++;
            }
            if(same == what.array.length) {
                indexArray.push(c);
            }
        }
        // pass 2 : concatenate substrings mixing the oryginal array with substitutes
        QuickStringWithCollectionOpt result = new QuickStringWithCollectionOpt();
        result.array = new char[array.length + (with.array.length - what.array.length) * indexArray.length()];
        for(int c = 0, prevIndex = 0, prevAdjustedIndex = 0; c < indexArray.length(); c++) {
            int newIndex = indexArray.get(c);
            int len = newIndex - prevIndex;
            System.arraycopy(array, prevIndex, result.array, prevAdjustedIndex, len);
            prevAdjustedIndex += len;
            System.arraycopy(with.array, 0, result.array, prevAdjustedIndex, with.array.length);
            prevAdjustedIndex += with.array.length;
            prevIndex = newIndex + what.array.length;
        }
        // append the remaining (unmodified) part
        int lastIndex = indexArray.tail() + what.array.length;
        int remainingLen = array.length - lastIndex;
        System.arraycopy(array, lastIndex, result.array, result.array.length - remainingLen, remainingLen);
        // return the result
        return result;
    }

    // a naive implementation of a growable skiplist-style collection
    private static class QuickIntList {
        private static final int skipStep = 64;
        int [][] array = new int[][] { new int[skipStep] };
        int occupancy = 0;
        public int get(int index) {
            if(index > occupancy) {
                throw new IndexOutOfBoundsException();
            } else {
                return array[index / skipStep][index % skipStep];
            }
        }
        public int tail() {
            return get(occupancy);
        }
        public void push(int value) {
            int index = occupancy;
            grow();
            array[index / skipStep][index % skipStep] = value;
            occupancy++;
        }
        private void grow() {
            if((occupancy % skipStep) == 0) {
                int [][] oldArray = array;
                array = new int[oldArray.length + 1][];
                System.arraycopy(oldArray, 0, array, 0, oldArray.length);
                array[oldArray.length] = new int[skipStep];
            }
        }
        public int length() {
            return occupancy;
        }
    }

}
```

## benchmark ##

I have tested the implemnetation by replacing space characters with a double underscore in a very long string:


```java
    private final static String testC = \"this a very long string with a lots of spaces that all need to be replaced with a double underscore character\";
    private final static String testCa = testC + testC + testC + testC + testC + testC + testC + testC + testC + testC; // 10 times testC
    private final static String testCase = testCa + testCa + testCa + testCa + testCa + testCa + testCa + testCa + testCa + testCa; // 10 times testCase
```

This is repeated 2000 times with 4 different methods:

* one using ``java.String.replace(java.String, java.String)``
* above implemnetation modified to use an fixed-size array instead of the ``QuickIntList``
* above implemnetation modified to use a java ArrayList instead of the ``QuickIntList``
* exact implemnetation given above

I am ignoring results of the first 100 iterations, giving VM time to warm up and compile.

## benchmark results ##

in ms (less is better), over 1900 iterations and after 100 of warm-up

AVERAGE

* String.replace(): 261493
* fixed array: 106408
* array list: 144285
* skip array: 124937

MEDIAN

* String.replace(): 260140
* fixed array: 99578
* array list: 144796
* skip array: 121943

PERCENTILE 0.75

* String.replace(): 294194
* fixed array: 112225
* array list: 160228
* skip array: 137558

PERCENTILE 0.25

* String.replace(): 165867
* fixed array: 76697
* array list: 100725
* skip array: 83212

The implementation above always beats java by being at least twice as fast. The ``QuickIntList`` seems to have a great impact on the results, as the fixed-size array (primitive array) performs even better than any collection (complex object).

Enjoy.
