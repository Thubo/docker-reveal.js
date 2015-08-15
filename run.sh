#!/bin/bash

docker run --rm -v $(pwd)/slides:/slides/ -p 8000:8000 reveal
