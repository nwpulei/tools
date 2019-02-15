#!/bin/bash

#readfree account
email="readfreeEmail%40gmail.com"
#readfree password
password="readfreePassword"

#fateadm account 
fateadmPDaccount='1080000'
#fateadm key
fateadmPDKey='xxxxxxxxxxxxxxxxxxx'

#save cookie file
COOKIE_FILE="/tmp/cookies"
#save image 
IMAGE_FILE="/tmp/a.png"

source ./config

#获取登录页面
page=`curl 'https://readfree.me/auth/login/' \
-L \
-c "$COOKIE_FILE"  -b "$COOKIE_FILE" \
-H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' \
-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.80 Safari/537.36' \
-H 'DNT: 1' \
-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' \
-H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8' \
--compressed -vv 2>/dev/null`

echo "$page" | grep "book-item" 1>/dev/null
if [ $? -eq 0 ]; then
	echo "login success"
	echo "view home page sucess"
	exit 0
fi

#无论是否登录状态 这里都会返回正常的登录页面
#echo "$page"

page=`echo  "$page"| sed "s/'/\"/g"`
csrfmiddlewaretoken=`echo  "$page" | grep "csrfmiddlewaretoken" | grep -o 'value="[^""]*' |grep -o '[^"]*$'`
captcha_0=`echo  "$page" | grep captcha_0 | grep -o 'value="[^""]*' |grep -o '[^"]*$'`

if [ -z "$csrfmiddlewaretoken" ] || [ -z "$captcha_0" ]; then
	echo "get csrf from page error。 page context"
	echo "$page"
	exit 1
fi

#获取验证码
curl "https://readfree.me/captcha/image/$captcha_0/" \
-c "$COOKIE_FILE"  -b "$COOKIE_FILE" \
-H 'Pragma: no-cache' -H 'DNT: 1' -H 'Accept-Encoding: gzip, deflate' \
-H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8' \
-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.80 Safari/537.36' \
-H 'Accept: image/webp,image/apng,image/*,*/*;q=0.8' \
-H 'Referer: https://readfree.me/auth/login/' \
-H 'Connection: keep-alive' -H 'Cache-Control: no-cache'  \
-o "$IMAGE_FILE"  --compressed -vv 2>/dev/null

if [ ! -s "$IMAGE_FILE" ]; then
	echo "get captcha image error. image path $IMAGE_FILE"
	exit 1
fi

#sleep 20

captcha_1=`bash ./imageReg.sh "$IMAGE_FILE" "$fateadmPDaccount" "$fateadmPDKey"`


if [ -z "$captcha_1" ];then
	echo "get image char error. image path $IMAGE_FILE"
	exit 1
fi


fromData="csrfmiddlewaretoken=$csrfmiddlewaretoken&login=$email&password=$password&captcha_0=$captcha_0&captcha_1=$captcha_1"

echo $fromData


#登录
#login
page=`curl 'https://readfree.me/auth/login/?next=/' \
-c "$COOKIE_FILE"  -b "$COOKIE_FILE" \
-L \
-H 'Connection: keep-alive' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' \
-H 'Origin: http://readfree.me' -H 'Upgrade-Insecure-Requests: 1' -H 'DNT: 1' \
-H 'Content-Type: application/x-www-form-urlencoded' \
-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.80 Safari/537.36' \
-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' \
-H 'Referer: https://readfree.me/auth/login/?next=/' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8' \
--data "$fromData" --compressed -vv 2>/dev/null`



echo "$page" | grep "认证码错误" 1>/dev/null
if [ $? -eq 0 ]; then
	echo "$page"
	echo "认证码错误"
	echo "image path $IMAGE_FILE,$captcha_1"
	exit 1
fi

echo "$page" | grep "book-item" 1>/dev/null
if [ $? -eq 0 ]; then
	echo "login success"
	echo "view home page sucess"
else
	echo "login maybe error"
	echo "$page"
fi

