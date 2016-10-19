#!/bin/bash
save_file="score" # 临时文件
semester=20142 # 刷分的学期, 20102代表2010年第二学期
jw_home="http://jwas3.nju.edu.cn:8080/jiaowu" # 教务网站首页地址
jw_login="http://jwas3.nju.edu.cn:8080/jiaowu/login.do" # 登录页面地址
jw_query="http://jwas3.nju.edu.cn:8080/jiaowu/student/studentinfo/achievementinfo.do?method=searchTermList&termCode=$semester" # 分数查询页面地址

name="141242068"
passwd="******"

cookie=`wget -q -O - $jw_home --save-headers | \
    sed -n 's/Set-Cookie: JSESSIONID=\([0-9A-Z]\+\);.*$/\1/p'`

# get session id
wget -q -O tmp --header="Cookie:JSESSIONID=$cookie" --post-data \
    "userName=${name}&password=${passwd}" "$jw_login" &> /dev/null

wget -q -O tmp --header="Cookie:JSESSIONID=$cookie" "$jw_query"

