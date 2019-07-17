#!/bin/bash

set -e

msg=$1
if [[ -z "$msg" ]]; then
  echo "提交信息不能为空"
  exit -1
fi

# 首次需要运行 gitbook install 安装 book.json 中要到的插件
# 如果部署站点为 https 的话，还需要修改 cnzz 的目标地址为 https，具体如下
# 修改 node_modules\gitbook-plugin-cnzz\book\plugin.js，将 s95.cnzz.com 前的 http 改为 https

bash compile.sh "$msg"

bash publish.sh "$msg"
