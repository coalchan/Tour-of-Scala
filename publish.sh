#!/bin/bash

set -e

git checkout master

echo "---------------------------gitbook build..."
gitbook build

echo "---------------------------push to gh-pages..."
gh-pages -d _book
