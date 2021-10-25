---
layout: post
title:  "canvas syntax highlighting text editor"
date:   2016-10-24
tags:
- poc
- javascript
- html5
- canvas
---

# javascript canvas syntax highlighting text editor #

A fun little experiment I did 3 years ago: find out if html5 canvas can be used to render a syntax highlighting editor.

![](canvas.png)

I have created a simple text editor in javascript 3 years ago.
It was a quick proof of concept to see if browsers can render the editor quick enought to keep it usable.

It uses jQuery to wrap the canvas and handle key strokes.
It's a plain javascript rendering on the canvas with a trival array as the backend buffer.

The interesting fact is that I remember abandoning the project because the repaint cycles triggered by keyboard
events were taking too much time. It was too slow.
However, now I can see it works smoothly on Firefox and Chrome.
It seems there must have been many performance improvements made over the last 3 years.

You can play with it on [jsfiddle](https://jsfiddle.net/ksiuda/qgjsf33k/).

I'm publishing this today as \"public domain\", since the concept could be worth another attempt.
