#!/bin/bash
docker run --rm -it -v `pwd`:/src/ --user 1000:1000 -p 1313:1313 klakegg/hugo:0.81.0 build
docker run --rm -it -v `pwd`/public:/src/ --user 1000:1000 --env AWS_ACCESS_KEY_ID --env AWS_SECRET_ACCESS_KEY amazon/aws-cli s3 sync /src s3://log.siuda.net/  --delete

