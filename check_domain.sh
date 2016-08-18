#!/bin/bash
# Filename:    check_domain.sh
# Revision:    1.0
# Date:        2016/05/16
# Author:      Channing Liu


#Curl website version.txt check http stuats 200 & project name output to result.txt
while read domain;
do
curl -i  "http://$domain/version.txt" 2>&1 | grep 'HTTP/1.1 200 OK\|a03_phpwww' > httpstatus.txt
http=`head -n 1 httpstatus.txt| awk '{print $2}'`
product=`tail -n 1 httpstatus.txt | awk '{print $3}'`
if [[ $http == 200 ]] && [[ $product == a03_phpwww ]];
        then
                echo "$domain Check Helth" > /dev/null 
        else
                echo "   $domain" >> result.txt
fi
done < domain.txt

file=/Users/channingliu/script
result=`cat $file/result.txt`
#dns=`cat /etc/resolv.conf | grep nameserver | awk '{print $2}'`
ip=`ifconfig en0 | awk '{ print $2}' | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`

#Mail Alert Function
function mail ()
{
cat > $file/mail << EOF
Subject: 【A03】域名国内测试异常
From: channing342@gmail.com
To: channing342@gmail.com

Daer Channing,
1:w
   请检查下列域名,在国内外租：$ip 上是解析是否异常，谢谢。

$result

Best Regards

B2

SA/运维部/ 
EOF
cat $file/mail | /usr/sbin/sendmail -t
}

#检查是否有解析异常结果文件,如有自动发信
if [ -f $file/result.txt ]
        then
               mail
        else
               echo 'Good'
fi
rm $file/result.txt
