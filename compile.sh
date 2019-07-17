#!/bin/bash

set -e

msg=$1
if [[ -z "$msg" ]]; then
  echo "提交信息不能为空"
  exit -1
fi
git checkout master

echo "---------------------------commit source..."
git add .
git commit -m "$msg"

echo "---------------------------push source..."

git push origin master

