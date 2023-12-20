#!/bin/bash
docker run --rm -it -v `pwd`:/src/ --user 1000:1000 -p 1313:1313 klakegg/hugo:0.81.0 serve

