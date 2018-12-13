**说明**   
访问主页 [readfree.me](http://readfree.me)  
必要时调用登录，并存储cookie,避免每次访问时均要登录的问题。  
**使用方法**  
修改config 文件中的参数  

|  name   |  参数说明   |   例如  |
| --- | --- | --- |
|  email   |   readfree 账户  |   readfreeEmail%40gmail.com  |
|  password   |   readfree 密码  |   readfreePassword  |
|  fateadmPDaccount   |   fateadm 站点的PD账号   |  1080000   |
|  fateadmPDKey   |   fateadm 站点的PD秘钥   |  xxxxxxxxxxxxxxxxxxx   |
|  COOKIE_FILE   |  cookie 临时存储路径   |   /tmp/cookies  |
|  IMAGE_FILE   |  验证码临时储存路径   |  /tmp/a.png   |

bash ./readfree.sh  
**依赖说明**  
需要用到下列工具curl,grep,sed,awk,md5(或者md5sum),date  
****关于自动登录****  
该脚本没有识别验证码能力，识别验证码用的是[fateadm](http://www.fateadm.com)提供的有偿服务。需要自动登录的，请前往[fateadm](http://www.fateadm.com)注册用户，获取用户id以及ukey。

***其他说明***  
脚本可以独立使用  
例如 验证码识别(不需要配置config)  
bash imageReg.sh "$IMAGE_FILE" "$fateadmPDaccount" "$fateadmPDKey"  
单纯登录readfree(需要配置config)  
bash login.sh  
