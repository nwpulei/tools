#!/bin/bash

#set -x
COOKIE_FILE="/tmp/cookies"
source ./config
#use config COOKIE_FILE value

date "+%Y-%m-%d %H:%M:%S"
page=`curl 'http://readfree.me/' \
-c "$COOKIE_FILE"  -b "$COOKIE_FILE" \
-L  \
-H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' -H 'Upgrade-Insecure-Requests: 1' -H 'DNT: 1' \
-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Safari/537.36' \
-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' \
-H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8' \
--compressed  -vv `

#-H "$cookie" \

loged=`echo "$page" | grep "id_signin_form"`
if [ -n  "$loged" ];then
    echo "需要重新登录"
    bash ./login.sh
else
    echo "页面ok"
fi


