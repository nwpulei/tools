#!/bin/bash
#set -x
#采用 http://www.fateadm.com/ 识别验证码

#$1 图片路径 $2 PD账号 $3 PD秘钥

imagePath="$1"
user_id="$2"
ukey="$3"

#图片类型 http://www.fateadm.com/price.html
predict_type=20400

function calcMd5(){
	which md5 >/dev/null
	if [ 0 -eq $? ];then
		#mac have md5,but md5sum cann't found
		md5 -q -s "$1"
	else
		echo -n "$1" |  md5sum - | awk '{print $1}'
	fi
}

function calcSign(){
	#usr_id, passwd, timestamp
	csign=`calcMd5 "$3$2"`
	calcMd5 "$1$3$csign"
}

img_data=`base64 -i "$imagePath" | sed 's/+/%2B/g;s/\//%2F/g;s/=/%3D/g'`

#set -x

timestamp=`date +%s`
sign=`calcSign "$user_id" "$ukey" "$timestamp"`
data="user_id=$user_id&timestamp=$timestamp&sign=$sign&predict_type=$predict_type&img_data=$img_data"

respon=`curl 'http://pred.fateadm.com/api/capreg' -H 'Pragma: no-cache' -H 'Origin: http://www.fateadm.com' \
-H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8' \
-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.80 Safari/537.36' \
-H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: */*' -H 'Cache-Control: no-cache' \
--data "$data" --compressed -vv 2>/dev/null`
echo $respon >&2
#{"RetCode":"0","ErrMsg":"","RequestId":"20xxxxxxxxxx","RspData":"{\"result\": \"uaak\"}"}
echo "$respon" | sed 's/\\//g'| grep -o  "result.*" | awk -F'"' '{print $3}'

#echo "HANF"



