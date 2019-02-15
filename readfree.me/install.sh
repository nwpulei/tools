#!/bin/bash
# 安装程序

echo "                                                                                         "
echo "     将会安装到当前目录的readfree.me中                                                      "
echo "     在config文件中设置相应的参数	                                                           "
echo "     运行  bash ./readfree.sh                                                             "
echo "                                                                                         "
echo "                                                                                         "
echo ""

mkdir readfree.me 
cd readfree.me
wget --no-cache --no-check-certificate https://raw.githubusercontent.com/nwpulei/tools/master/readfree.me/config 2>/dev/null
wget --no-cache --no-check-certificate https://raw.githubusercontent.com/nwpulei/tools/master/readfree.me/README.md 2>/dev/null
wget --no-cache --no-check-certificate https://raw.githubusercontent.com/nwpulei/tools/master/readfree.me/imageReg.sh 2>/dev/null
wget --no-cache --no-check-certificate https://raw.githubusercontent.com/nwpulei/tools/master/readfree.me/login.sh 2>/dev/null
wget --no-cache --no-check-certificate https://raw.githubusercontent.com/nwpulei/tools/master/readfree.me/readfree.sh 2>/dev/null

echo "   安装完成"
