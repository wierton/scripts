#coding=utf-8

import re
import urllib
import urllib2

semester= '20152' # 刷分的学期, 20102代表2010年第二学期
jw_home = "http://jwas2.nju.edu.cn:8080/jiaowu/" # 教务网站首页地址
jw_login= "http://jwas2.nju.edu.cn:8080/jiaowu/login.do" # 登录页面地址
jw_query= 'http://jwas2.nju.edu.cn:8080/jiaowu/student/studentinfo/achievementinfo.do?method=searchTermList&termCode='

SESSION_ID = ''

name="141242068"
passwd=""

def get_session_id():
    request    = urllib2.Request(jw_home)
    response   = urllib2.urlopen(request)
    JSESSIONID = (response.info()).getheader('set-cookie')
    pa         = re.compile(r'[0-9A-F]{5,}')
    cookie     = re.search(pa, JSESSIONID)
    return cookie.group()

def login():
    headers = {'Cookie':'JSESSIONID='+SESSION_ID}
    values  = {'userName':name, 'password':passwd}
    data    = urllib.urlencode(values)
    request = urllib2.Request(jw_login, data=data, headers=headers)
    response= urllib2.urlopen(request)

def get_html():
    headers  = {'Cookie':'JSESSIONID=' + SESSION_ID}
    request  = urllib2.Request(jw_query+semester, headers=headers)
    response = urllib2.urlopen(request)
    return response.read()

def get_score(html):
    pa = re.compile(r'class="TABLE_TR_\d{2}".*?<td.*?<td.*?<td.*?>(.*?)</td>.*?<td.*?<td.*?<td.*?<td.*?<ul.*?>.*?(\d*\.\d*).*?</ul>', re.S)
    items = pa.findall(html)
    for item in items:
        print item[0], '\t', item[1]

def parse_args():
    import getopt, sys
    opts, args = getopt.getopt(sys.argv[1:], "u:p:t:", ['user=', 'password=', 'term='])
    global name, passwd, semester
    for opt,arg in opts:
        if opt in ('-u', '--user'):
            name = arg
        elif opt in ('-p', '--password'):
            passwd = arg
        elif opt in ('-t', '--term'):
            semester = arg
    if passwd == '':
        sys.stderr.write('password not specified!\n')
        exit(0)

try:
    parse_args()
    SESSION_ID = get_session_id()
    login()
    html = get_html()
    get_score(html)
except urllib2.URLError, e:
    print e.reason
