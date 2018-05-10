#!/usr/bin/env bash
set -u
set -e
set -o noclobber

docker build -t genzouw/vertica:9.0.1 .
